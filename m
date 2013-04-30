Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177Ab3D3RJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:09:44 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:44517
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761018Ab3D3RJk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:09:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz9371I542I1432Ic8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2ehbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Topic: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Thread-Index: AQHOQOEVXyYrk6lRr0mRMnByFKC5lpjvCPDA
Date: Tue, 30 Apr 2013 17:09:32 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D4CBC45@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1366803351-17429-1-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1366803351-17429-1-git-send-email-Varun.Sethi@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.221]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
Would you take this patchset for 3.10 merge?

Regards
Varun

> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Wednesday, April 24, 2013 5:06 PM
> To: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> galak@kernel.crashing.org; benh@kernel.crashing.org; Yoder Stuart-B08248;
> Wood Scott-B07421
> Cc: Sethi Varun-B16395
> Subject: [PATCH 1/2 v15] iommu/fsl: Add additional iommu attributes
> required by the PAMU driver.
> 
> Added the following domain attributes for the FSL PAMU driver:
> 1. Added new iommu stash attribute, which allows setting of the
>    LIODN specific stash id parameter through IOMMU API.
> 2. Added an attribute for enabling/disabling DMA to a particular
>    memory window.
> 3. Added domain attribute to check for PAMUV1 specific constraints.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> v15 changes:
> - Moved fsl_pamu_stash.h under arch/powerpc/include/asm.
> v14 changes:
> - Add FSL prefix to PAMU attributes.
> v13 changes:
> - created a new file include/linux/fsl_pamu_stash.h for stash attributes.
> v12 changes:
> - Moved PAMU specifc stash ids and structures to PAMU header file.
> - no change in v11.
> - no change in v10.
>  arch/powerpc/include/asm/fsl_pamu_stash.h |   39
> +++++++++++++++++++++++++++++
>  include/linux/iommu.h                     |   16 ++++++++++++
>  2 files changed, 55 insertions(+), 0 deletions(-)  create mode 100644
> arch/powerpc/include/asm/fsl_pamu_stash.h
> 
> diff --git a/arch/powerpc/include/asm/fsl_pamu_stash.h
> b/arch/powerpc/include/asm/fsl_pamu_stash.h
> new file mode 100644
> index 0000000..caa1b21
> --- /dev/null
> +++ b/arch/powerpc/include/asm/fsl_pamu_stash.h
> @@ -0,0 +1,39 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> USA.
> + *
> + * Copyright (C) 2013 Freescale Semiconductor, Inc.
> + *
> + */
> +
> +#ifndef __FSL_PAMU_STASH_H
> +#define __FSL_PAMU_STASH_H
> +
> +/* cache stash targets */
> +enum pamu_stash_target {
> +	PAMU_ATTR_CACHE_L1 = 1,
> +	PAMU_ATTR_CACHE_L2,
> +	PAMU_ATTR_CACHE_L3,
> +};
> +
> +/*
> + * This attribute allows configuring stashig specific parameters
> + * in the PAMU hardware.
> + */
> +
> +struct pamu_stash_attribute {
> +	u32 	cpu;	/* cpu number */
> +	u32 	cache;	/* cache to stash to: L1,L2,L3 */
> +};
> +
> +#endif  /* __FSL_PAMU_STASH_H */
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> 2727810..313d17a 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -57,10 +57,26 @@ struct iommu_domain {
>  #define IOMMU_CAP_CACHE_COHERENCY	0x1
>  #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
> 
> +/*
> + * Following constraints are specifc to FSL_PAMUV1:
> + *  -aperture must be power of 2, and naturally aligned
> + *  -number of windows must be power of 2, and address space size
> + *   of each window is determined by aperture size / # of windows
> + *  -the actual size of the mapped region of a window must be power
> + *   of 2 starting with 4KB and physical address must be naturally
> + *   aligned.
> + * DOMAIN_ATTR_FSL_PAMUV1 corresponds to the above mentioned contraints.
> + * The caller can invoke iommu_domain_get_attr to check if the
> +underlying
> + * iommu implementation supports these constraints.
> + */
> +
>  enum iommu_attr {
>  	DOMAIN_ATTR_GEOMETRY,
>  	DOMAIN_ATTR_PAGING,
>  	DOMAIN_ATTR_WINDOWS,
> +	DOMAIN_ATTR_FSL_PAMU_STASH,
> +	DOMAIN_ATTR_FSL_PAMU_ENABLE,
> +	DOMAIN_ATTR_FSL_PAMUV1,
>  	DOMAIN_ATTR_MAX,
>  };
> 
> --
> 1.7.4.1


