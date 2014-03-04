Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaCDPlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:41:24 -0500
Received: from 8bytes.org ([85.214.48.195]:58576 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaCDPlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:41:23 -0500
Date: Tue, 4 Mar 2014 16:41:18 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH] IOMMU: iommu module do not check NULL return of
 kmem_cache_zalloc
Message-ID: <20140304154117.GF2799@8bytes.org>
References: <1392084773-16843-1-git-send-email-zhouzhouyi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392084773-16843-1-git-send-email-zhouzhouyi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar  4 16:41:21 2014
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5315f42120861663839967
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:12:53AM +0800, Zhouyi Zhou wrote:
> From: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> 
> The function iopte_alloc do not check NULL return of kmem_cache_zalloc,
> call iopte_free with argument 0 will panic.
> 
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  drivers/iommu/omap-iommu.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index bcd78a7..5155714 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -551,7 +551,8 @@ static u32 *iopte_alloc(struct omap_iommu *obj, u32 *iopgd, u32 da)
>  		dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
>  	} else {
>  		/* We raced, free the reduniovant table */
> -		iopte_free(iopte);
> +		if (iopte)
> +			iopte_free(iopte);

Isn't it better to put the check into iopte_free?


	Joerg


