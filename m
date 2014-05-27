Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaE0Hnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:43:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41244 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbaE0Hnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:43:37 -0400
Date: Tue, 27 May 2014 09:43:33 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Antoine Tenart'" <antoine.tenart@free-electrons.com>,
        "'Sebastian Hesselbarth'" <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] pinctrl: berlin: Use devm_ioremap_resource()
Message-ID: <20140527074333.GA3768@kwain>
References: <000a01cf7974$fc9fc4d0$f5df4e70$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000a01cf7974$fc9fc4d0$f5df4e70$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 03:29:17PM +0900, Jingoo Han wrote:
> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>


Thanks!

Antoine

> ---
>  drivers/pinctrl/berlin/berlin-bg2.c   |    6 +++---
>  drivers/pinctrl/berlin/berlin-bg2cd.c |    6 +++---
>  drivers/pinctrl/berlin/berlin-bg2q.c  |    6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pinctrl/berlin/berlin-bg2.c b/drivers/pinctrl/berlin/berlin-bg2.c
> index 0d8fd50..dcd4f6a 100644
> --- a/drivers/pinctrl/berlin/berlin-bg2.c
> +++ b/drivers/pinctrl/berlin/berlin-bg2.c
> @@ -243,9 +243,9 @@ static int berlin2_pinctrl_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base)
> -		return -EADDRNOTAVAIL;
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
>  
>  	rmconfig->reg_bits = 32,
>  	rmconfig->val_bits = 32,
> diff --git a/drivers/pinctrl/berlin/berlin-bg2cd.c b/drivers/pinctrl/berlin/berlin-bg2cd.c
> index e095a5d..89d585e 100644
> --- a/drivers/pinctrl/berlin/berlin-bg2cd.c
> +++ b/drivers/pinctrl/berlin/berlin-bg2cd.c
> @@ -186,9 +186,9 @@ static int berlin2cd_pinctrl_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base)
> -		return -EADDRNOTAVAIL;
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
>  
>  	rmconfig->reg_bits = 32,
>  	rmconfig->val_bits = 32,
> diff --git a/drivers/pinctrl/berlin/berlin-bg2q.c b/drivers/pinctrl/berlin/berlin-bg2q.c
> index ab33a3b..9fcf983 100644
> --- a/drivers/pinctrl/berlin/berlin-bg2q.c
> +++ b/drivers/pinctrl/berlin/berlin-bg2q.c
> @@ -405,9 +405,9 @@ static int berlin2q_pinctrl_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base)
> -		return -EADDRNOTAVAIL;
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
>  
>  	rmconfig->reg_bits = 32,
>  	rmconfig->val_bits = 32,
> -- 
> 1.7.10.4
> 
> 

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
