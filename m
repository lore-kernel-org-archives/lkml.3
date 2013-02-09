Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688Ab3BIOUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:20:21 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52264 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3BIOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:20:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the samsung tree with the arm-soc tree
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20130131014801.09c81e1826a2fb234de85550@canb.auug.org.au>
References: <20130131014801.09c81e1826a2fb234de85550@canb.auug.org.au>
Date: Sat, 09 Feb 2013 14:20:14 +0000
Message-Id: <20130209142014.208ED3E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 01:48:01 +1100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Kukjin,
> 
> Today's linux-next merge of the samsung tree got a conflict in
> drivers/gpio/gpio-samsung.c between commits f69254328793 ("ARM: dts: Fix
> compatible value of pinctrl module on EXYNOS5440") and b533c8685b16
> ("ARM: dts: fix compatible value for exynos pinctrl") from the arm-soc
> tree and commit bda7f6d4e198 ("gpio: samsung: skip gpiolib registration
> if pinctrl support is enabled for exynos5250") from the samsung tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen.

g.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/gpio/gpio-samsung.c
> index b2016ed,0d46db6..0000000
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@@ -3023,9 -3023,9 +3022,10 @@@ static __init int samsung_gpiolib_init(
>   	*/
>   	struct device_node *pctrl_np;
>   	static const struct of_device_id exynos_pinctrl_ids[] = {
>  -		{ .compatible = "samsung,pinctrl-exynos4210", },
>  -		{ .compatible = "samsung,pinctrl-exynos4x12", },
>  -		{ .compatible = "samsung,pinctrl-exynos5250", },
>  +		{ .compatible = "samsung,exynos4210-pinctrl", },
>  +		{ .compatible = "samsung,exynos4x12-pinctrl", },
> ++		{ .compatible = "samsung,exynos5250-pinctrl", },
>  +		{ .compatible = "samsung,exynos5440-pinctrl", },
>   	};
>   	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
>   		if (pctrl_np && of_device_is_available(pctrl_np))
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
