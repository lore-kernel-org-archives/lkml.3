Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab3JNFOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:14:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:30239 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3JNFOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,489,1378882800"; 
   d="scan'208";a="392515425"
Message-ID: <1381727680.2034.1.camel@rzhang1-mobl4>
Subject: Re: [PATCHv4 1/9] Thermal: Check for validity before doing kfree
From: Zhang Rui <rui.zhang@intel.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com,
        wni@nvidia.com
Date: Mon, 14 Oct 2013 13:14:40 +0800
In-Reply-To: <1380652688-5787-2-git-send-email-durgadoss.r@intel.com>
References: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
	 <1380652688-5787-2-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 00:08 +0530, Durgadoss R wrote:
> The thermal_release function is called whenever
> any device belonging to 'thermal' class unregisters.
> This function performs kfree(cdev) without any check.
> In cases where there are more device registrations
> other than just 'thermal_zone' and 'cooling_device'
> this might accidently free memory allocated them
> silently; and cause memory errors.
> 
> This patch changes this behavior by doing
> kfree(cdev) only when the device pointer belongs
> to a real cdev i.e. cooling_device.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>

applied to thermal -next.

thanks,
rui
> ---
>  drivers/thermal/thermal_core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 1f02e8e..8c5131d 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1280,7 +1280,8 @@ static void thermal_release(struct device *dev)
>  		     sizeof("thermal_zone") - 1)) {
>  		tz = to_thermal_zone(dev);
>  		kfree(tz);
> -	} else {
> +	} else if(!strncmp(dev_name(dev), "cooling_device",
> +			sizeof("cooling_device") - 1)){
>  		cdev = to_cooling_device(dev);
>  		kfree(cdev);
>  	}


