Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3JaIqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:46:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50263 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3JaIqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:46:47 -0400
Message-ID: <527218F4.3090006@ti.com>
Date: Thu, 31 Oct 2013 14:16:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers: phy: Fix memory leak
References: <1382678784-20191-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1382678784-20191-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 25 October 2013 10:56 AM, Sachin Kamat wrote:
> 'phy' was not being freed upon error in one of the cases.
> Adjust the 'goto's to fix this.

This patch looks good. I'll send this once -rc1 is tagged?

Thanks
Kishon
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/phy/phy-core.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb..712b358 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -453,7 +453,7 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  	if (id < 0) {
>  		dev_err(dev, "unable to get id\n");
>  		ret = id;
> -		goto err0;
> +		goto err1;
>  	}
>  
>  	device_initialize(&phy->dev);
> @@ -468,11 +468,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  
>  	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
>  	if (ret)
> -		goto err1;
> +		goto err2;
>  
>  	ret = device_add(&phy->dev);
>  	if (ret)
> -		goto err1;
> +		goto err2;
>  
>  	if (pm_runtime_enabled(dev)) {
>  		pm_runtime_enable(&phy->dev);
> @@ -481,11 +481,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  
>  	return phy;
>  
> -err1:
> +err2:
>  	ida_remove(&phy_ida, phy->id);
>  	put_device(&phy->dev);
> +err1:
>  	kfree(phy);
> -
>  err0:
>  	return ERR_PTR(ret);
>  }
> 

