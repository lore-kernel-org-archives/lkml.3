Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab3DBP3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:29:40 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:58729
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932341Ab3DBP3j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:29:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Sethi Varun-B16395 <B16395@freescale.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: RE: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Topic: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Index: AQHOK+8tO/4GVyqmPkuty25lenzG/ZjDFW0g
Date: Tue, 2 Apr 2013 15:29:19 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15035A0D34@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-6-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1364500442-20927-6-git-send-email-Varun.Sethi@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.137.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Thursday, March 28, 2013 2:54 PM
> To: joro@8bytes.org; Yoder Stuart-B08248; Wood Scott-B07421; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; galak@kernel.crashing.org; benh@kernel.crashing.org
> Cc: Sethi Varun-B16395
> Subject: [PATCH 5/5 v11] iommu/fsl: Freescale PAMU driver and iommu implementation.
> 
> Following is a brief description of the PAMU hardware:
> PAMU determines what action to take and whether to authorize the action on
> the basis of the memory address, a Logical IO Device Number (LIODN), and
> PAACT table (logically) indexed by LIODN and address. Hardware devices which
> need to access memory must provide an LIODN in addition to the memory address.
> 
> Peripheral Access Authorization and Control Tables (PAACTs) are the primary
> data structures used by PAMU. A PAACT is a table of peripheral access
> authorization and control entries (PAACE).Each PAACE defines the range of
> I/O bus address space that is accessible by the LIOD and the associated access
> capabilities.
> 
> There are two types of PAACTs: primary PAACT (PPAACT) and secondary PAACT
> (SPAACT).A given physical I/O device may be able to act as one or more
> independent logical I/O devices (LIODs). Each such logical I/O device is
> assigned an identifier called logical I/O device number (LIODN). A LIODN is
> allocated a contiguous portion of the I/O bus address space called the DSA window
> for performing DSA operations. The DSA window may optionally be divided into
> multiple sub-windows, each of which may be used to map to a region in system
> storage space. The first sub-window is referred to as the primary sub-window
> and the remaining are called secondary sub-windows.
> 
> This patch provides the PAMU driver (fsl_pamu.c) and the corresponding IOMMU
> API implementation (fsl_pamu_domain.c). The PAMU hardware driver (fsl_pamu.c)
> has been derived from the work done by Ashish Kalra and Timur Tabi.
> 
> Signed-off-by: Timur Tabi <<timur@tabi.org>
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> changes in v11:
> - changed iova to dma_addr_t in iova_to_phys API.
> changes in v10:
> - Support for new guts compatibe string for T4 & B4 devices.
> - Modified comment about port ID and mentioned the errata number.
> - Fixed the issue where data pointer was not freed in case of a an error.
> - Pass data pointer while freeing irq.
> - Whle initializing the SPAACE entry clear the valid bit.
> changes in v9:
> - Merged and createad a single function to delete
> a device from domain list.
> - Refactored the add_device API code.
> - Renamed the paace and spaace init fucntions.
> - Renamed functions for mapping windows and subwindows.
> - Changed the MAX LIODN value to MAX value u-boot can
> program.
> - Hard coded maximum number of subwindows.
> changes in v8:
> - implemented the new API for window based IOMMUs.
> changes in v7:
> - Set max_subwidows in the geometry attribute.
> - Add checking for maximum supported LIODN value.
> - Use upper_32_bits and lower_32_bits macros while
>   intializing PAMU data structures.
> changes in v6:
> - Simplified complex conditional statements.
> - Fixed indentation issues.
> - Added comments for IOMMU API implementation.
> changes in v5:
> - Addressed comments from Timur.
> changes in v4:
> - Addressed comments from Timur and Scott.
> changes in v3:
> - Addressed comments by Kumar Gala
> - dynamic fspi allocation
> - fixed alignment check in map and unmap
>  arch/powerpc/sysdev/fsl_pci.h   |    5 +
>  drivers/iommu/Kconfig           |    8 +
>  drivers/iommu/Makefile          |    1 +
>  drivers/iommu/fsl_pamu.c        | 1269 +++++++++++++++++++++++++++++++++++++++
>  drivers/iommu/fsl_pamu.h        |  405 +++++++++++++
>  drivers/iommu/fsl_pamu_domain.c | 1137 +++++++++++++++++++++++++++++++++++
>  drivers/iommu/fsl_pamu_domain.h |   85 +++
>  7 files changed, 2910 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/iommu/fsl_pamu.c
>  create mode 100644 drivers/iommu/fsl_pamu.h
>  create mode 100644 drivers/iommu/fsl_pamu_domain.c
>  create mode 100644 drivers/iommu/fsl_pamu_domain.h

Ack.

Stuart

