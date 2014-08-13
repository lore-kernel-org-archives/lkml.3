Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaHMBqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 21:46:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54866 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaHMBqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 21:46:38 -0400
Message-ID: <53EAC37C.4020203@codeaurora.org>
Date: Tue, 12 Aug 2014 18:46:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stepan Moskovchenko <stepanm@codeaurora.org>
CC: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] of: Deep-copy names of platform devices
References: <1407891444-7311-1-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1407891444-7311-1-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 17:57, Stepan Moskovchenko wrote:
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index f685e55..3e116f6 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -54,7 +54,7 @@ int of_device_add(struct platform_device *ofdev)
>
>  	/* name and id have to be set so that the platform bus doesn't get
>  	 * confused on matching */
> -	ofdev->name = dev_name(&ofdev->dev);
> +	ofdev->name = kstrdup(dev_name(&ofdev->dev), GFP_KERNEL);
>  	ofdev->id = -1;
>
>  	/* device_add will assume that this device is on the same node as
> @@ -76,6 +76,7 @@ EXPORT_SYMBOL(of_device_register);
>  void of_device_unregister(struct platform_device *ofdev)
>  {
>  	device_unregister(&ofdev->dev);
> +	kfree(ofdev->name);

This probably ought to be swapped because we don't know if ofdev isn't
pointing to freed memory after device_unregister().

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

