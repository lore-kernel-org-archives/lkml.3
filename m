Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaIQIa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:30:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaIQIa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:30:56 -0400
Date: Wed, 17 Sep 2014 10:30:53 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Upinder Malhi <umalhi@cisco.com>
Subject: Re: [PATCH 11/12] IB/usnic: Convert to use new iommu_capable() API
 function
Message-ID: <20140917083053.GD2533@suse.de>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
 <1409914384-21191-12-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409914384-21191-12-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 05, 2014 at 12:53:03PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Cc: Upinder Malhi <umalhi@cisco.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/infiniband/hw/usnic/usnic_uiom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 801a1d6..417de1f 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -507,7 +507,7 @@ int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
>  	if (err)
>  		goto out_free_dev;
>  
> -	if (!iommu_domain_has_cap(pd->domain, IOMMU_CAP_CACHE_COHERENCY)) {
> +	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
>  		usnic_err("IOMMU of %s does not support cache coherency\n",
>  				dev_name(dev));
>  		err = -EINVAL;

Any objections against this? I would like to apply this series to the
iommu tree.


	Joerg
