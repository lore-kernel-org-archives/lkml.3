Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaLQVlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:41:46 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41560 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLQVlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:41:45 -0500
Date: Wed, 17 Dec 2014 14:41:44 -0700
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, Myron Stowe <mstowe@redhat.com>
Subject: Re: [PATCH 2/2] iommu/vt-d: Remove dead code in device_notifier
Message-ID: <20141217214144.GB11569@anatevka.fc.hp.com>
Reply-To: Jerry.Hoemann@hp.com
References: <1418813017-24888-1-git-send-email-joro@8bytes.org>
 <1418813017-24888-2-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418813017-24888-2-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:43:37AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> This code only runs when action == BUS_NOTIFY_REMOVED_DEVICE,
> so it can't be BUS_NOTIFY_DEL_DEVICE.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/intel-iommu.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 7610121..40dfbc0 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4029,14 +4029,6 @@ static int device_notifier(struct notifier_block *nb,
>  	if (action != BUS_NOTIFY_REMOVED_DEVICE)
>  		return 0;
>  
> -	/*
> -	 * If the device is still attached to a device driver we can't
> -	 * tear down the domain yet as DMA mappings may still be in use.
> -	 * Wait for the BUS_NOTIFY_UNBOUND_DRIVER event to do that.
> -	 */
> -	if (action == BUS_NOTIFY_DEL_DEVICE && dev->driver != NULL)
> -		return 0;
> -
>  	domain = find_domain(dev);
>  	if (!domain)
>  		return 0;
> -- 
> 1.9.1

Joerg,

Tested this along w/ other patch of the set.

Instrumentation showed that the removed code wouldn't have been executed
during VM power on/power off.

Thanks!

Tested-by: Jerry Hoemann <jerry.hoemann@hp.com>


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 36                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-0707
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------
