Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab3BYKQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:16:07 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:1280
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758199Ab3BYKQF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:16:05 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz9371I542I1432Id799hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>
Subject: RE: [PATCH 0/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Topic: [PATCH 0/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
 implementation.
Thread-Index: AQHODdfDKVgpdKNsGEqiH9csG+zsMJiKZjmg
Date: Mon, 25 Feb 2013 10:15:55 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3B8CF1@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
Do you have any comments on the patch set.

Regards
Varun

> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Monday, February 18, 2013 6:22 PM
> To: iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> linux-kernel@vger.kernel.org; Wood Scott-B07421; joro@8bytes.org; Yoder
> Stuart-B08248
> Cc: Sethi Varun-B16395
> Subject: [PATCH 0/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API
> implementation.
> 
> This patchset provides the Freescale PAMU (Peripheral Access Management
> Unit) driver and the corresponding IOMMU API implementation. PAMU is the
> IOMMU present on Freescale QorIQ platforms. PAMU can authorize memory
> access, remap the memory address, and remap the I/O transaction type.
> 
> This set consists of the following patches:
> 1. Addition of new field in the device (powerpc) archdata structure for
> storing iommu domain information
>    pointer. This pointer is stored when the device is attached to a
> particular iommu domain.
> 2. Store PCI controller platform device information in the PCI controller
> structure.
> 3. Add defines for FSL PCI controller BRR1 register.
> 4. Add window permission flags in the iommu_domain_window_enable API.
> 5. Add domain attributes for FSL PAMU driver.
> 6. PAMU driver and IOMMU API implementation.
> 
> This patch set is based on the next branch of the iommu git tree
> maintained by Joerg.
> 
> Varun Sethi (6):
>   Store iommu domain information in the device structure.
>   Store the platform device information corresponding to the pci
>     controller.
>   Added defines for the FSL PCI controller BRR1 register.
>   Add window permission flags for iommu_domain_window_enable API.
>   Add addtional attributes specific to the PAMU driver.
>   FSL PAMU driver and IOMMU API implementation.
> 
>  arch/powerpc/include/asm/device.h     |    4 +
>  arch/powerpc/include/asm/pci-bridge.h |    4 +
>  arch/powerpc/sysdev/fsl_pci.c         |    9 +-
>  arch/powerpc/sysdev/fsl_pci.h         |    2 +-
>  drivers/iommu/Kconfig                 |    8 +
>  drivers/iommu/Makefile                |    1 +
>  drivers/iommu/fsl_pamu.c              | 1260
> +++++++++++++++++++++++++++++++++
>  drivers/iommu/fsl_pamu.h              |  398 +++++++++++
>  drivers/iommu/fsl_pamu_domain.c       | 1135
> +++++++++++++++++++++++++++++
>  drivers/iommu/fsl_pamu_domain.h       |   89 +++
>  drivers/iommu/iommu.c                 |    5 +-
>  include/linux/iommu.h                 |   40 +-
>  12 files changed, 2947 insertions(+), 8 deletions(-)  create mode 100644
> drivers/iommu/fsl_pamu.c  create mode 100644 drivers/iommu/fsl_pamu.h
> create mode 100644 drivers/iommu/fsl_pamu_domain.c  create mode 100644
> drivers/iommu/fsl_pamu_domain.h
> 
> --
> 1.7.4.1


