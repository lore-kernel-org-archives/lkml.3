Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaAFJsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:48:14 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49655 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAFJsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:48:13 -0500
Date: Mon, 6 Jan 2014 09:48:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 01/18] mfd: syscon: Consider platform data a regmap config
 name
Message-ID: <20140106094808.GG23772@lee--X1>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-2-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387815830-8794-2-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use the device platform data as a regmap config
> name. This is particularly useful in the regmap
> debugfs when there is more than one syscon device
> registered, to distinguish the register blocks.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
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
>  	syscon->regmap = devm_regmap_init_mmio(dev, base,
>  					&syscon_regmap_config);
>  	if (IS_ERR(syscon->regmap)) {

This smells a bit fishy to me. Can you point me to the piece of code
or patch where you set the platform_data pointer as a string?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
