Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaBKRYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:24:48 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:34074 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaBKRYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:24:47 -0500
Date: Tue, 11 Feb 2014 17:24:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 07/12] mfd: syscon: Consider platform data a regmap
 config name
Message-ID: <20140211172440.GG15081@lee--X1>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <1392138636-29240-8-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392138636-29240-8-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use the device platform data as a regmap config
> name. This is particularly useful in the regmap
> debugfs when there is more than one syscon device
> registered, to distinguish the register blocks.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
> Alternatively I could define a syscon platform data structure,
> something like this:
> 
> struct syscon_platform_data {
> 	const char *label;
> };
> 
>  drivers/mfd/syscon.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 71841f9..ea1770b 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -143,6 +143,7 @@ static int syscon_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	syscon_regmap_config.max_register = res->end - res->start - 3;
> +	syscon_regmap_config.name = dev_get_platdata(&pdev->dev);

Perhaps the answer is waiting for me in the other set, but ...

Isn't this going to be NULL most of the time?

>  	syscon->regmap = devm_regmap_init_mmio(dev, base,
>  					&syscon_regmap_config);
>  	if (IS_ERR(syscon->regmap)) {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
