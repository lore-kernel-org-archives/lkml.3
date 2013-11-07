Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3KGR5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:57:16 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53129 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230Ab3KGR5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:57:13 -0500
Message-ID: <527BD477.2090602@free-electrons.com>
Date: Thu, 07 Nov 2013 18:57:11 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, rob.herring@calxeda.com,
        linux@arm.linux.org.uk, kernel@pengutronix.de, baohua@kernel.org,
        dinguyen@altera.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] pinctrl: mvebu: Convert to use devm_ioremap_resource
References: <1383793720-4643-1-git-send-email-jszhang@marvell.com> <1383793720-4643-7-git-send-email-jszhang@marvell.com>
In-Reply-To: <1383793720-4643-7-git-send-email-jszhang@marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 04:08, Jisheng Zhang wrote:
> The resource mapped by of_iomap() isn't unmapped in error path. This
> patch fix the resource leakage by using devm_ioremap_resource() instead
> of of_iomap().
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Acked-by: Jason Cooper <jason@lakedaemon.net>

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory

> ---
>  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> index bb7ddb1..1caa45f 100644
> --- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> +++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> @@ -579,7 +579,7 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
>  int mvebu_pinctrl_probe(struct platform_device *pdev)
>  {
>  	struct mvebu_pinctrl_soc_info *soc = dev_get_platdata(&pdev->dev);
> -	struct device_node *np = pdev->dev.of_node;
> +	struct resource *res;
>  	struct mvebu_pinctrl *pctl;
>  	void __iomem *base;
>  	struct pinctrl_pin_desc *pdesc;
> @@ -591,11 +591,10 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	base = of_iomap(np, 0);
> -	if (!base) {
> -		dev_err(&pdev->dev, "unable to get base address\n");
> -		return -ENODEV;
> -	}
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
>  
>  	pctl = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_pinctrl),
>  			GFP_KERNEL);
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
