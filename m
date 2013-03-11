Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3CKVqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:46:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39131 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3CKVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:46:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, horms+renesas@verge.net.au
Cc: linus.walleij@linaro.org, lethal@linux-sh.org,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] sh-pfc: fix return value check in sh_pfc_register_pinctrl()
Date: Mon, 11 Mar 2013 22:47:17 +0100
Message-ID: <3676378.u1106u4Bhi@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CAPgLHd-SZw14C_jDYrGNyYWJ7XafX--NEaF9+QofAcm9CuFK_w@mail.gmail.com>
References: <CAPgLHd-SZw14C_jDYrGNyYWJ7XafX--NEaF9+QofAcm9CuFK_w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

Thank you for the patch.

On Monday 11 March 2013 22:08:12 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function pinctrl_register() returns
> NULL not ERR_PTR(). The IS_ERR() test in the return value
> check should be replaced with NULL test.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patch in my tree and will push it to v3.10.

> ---
>  drivers/pinctrl/sh-pfc/pinctrl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c
> b/drivers/pinctrl/sh-pfc/pinctrl.c index 11e0e13..271e2c1 100644
> --- a/drivers/pinctrl/sh-pfc/pinctrl.c
> +++ b/drivers/pinctrl/sh-pfc/pinctrl.c
> @@ -439,8 +439,8 @@ int sh_pfc_register_pinctrl(struct sh_pfc *pfc)
>  		return ret;
> 
>  	pmx->pctl = pinctrl_register(&sh_pfc_pinctrl_desc, pfc->dev, pmx);
> -	if (IS_ERR(pmx->pctl))
> -		return PTR_ERR(pmx->pctl);
> +	if (!pmx->pctl)
> +		return -EINVAL;
> 
>  	sh_pfc_gpio_range.npins = pfc->info->last_gpio
>  				- pfc->info->first_gpio + 1;

-- 
Regards,

Laurent Pinchart

