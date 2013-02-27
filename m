Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3B0Lau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:30:50 -0500
Received: from 8bytes.org ([85.214.48.195]:35923 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521Ab3B0Lat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:30:49 -0500
Date: Wed, 27 Feb 2013 12:30:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, scottwood@freescale.com,
        stuart.yoder@freescale.com
Subject: Re: [PATCH 1/6 v8] iommu/fsl: Store iommu domain information pointer
 in archdata.
Message-ID: <20130227113045.GH26252@8bytes.org>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
 <1361191939-21260-2-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361191939-21260-2-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb 27 12:30:47 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 512dee6722971451514004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 06:22:14PM +0530, Varun Sethi wrote:
> Add a new field in the device (powerpc) archdata structure for storing iommu domain
> information pointer. This pointer is stored when the device is attached to a particular
> domain.
> 
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> - no change.
>  arch/powerpc/include/asm/device.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
> index 77e97dd..6dc79fe 100644
> --- a/arch/powerpc/include/asm/device.h
> +++ b/arch/powerpc/include/asm/device.h
> @@ -28,6 +28,10 @@ struct dev_archdata {
>  		void		*iommu_table_base;
>  	} dma_data;
>  
> +	/* IOMMU domain information pointer. This would be set
> +	 * when this device is attached to an iommu_domain.
> +	 */
> +	void			*iommu_domain;

Please Cc the PowerPC Maintainers on this, so that they can have a look
at it. This also must be put this into an #ifdef CONFIG_IOMMU_API.


	Joerg


