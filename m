Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3FEQih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:38:37 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:53507 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab3FEQig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:38:36 -0400
Date: Wed, 5 Jun 2013 20:38:31 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: Let device core handle pinctrl
Message-ID: <20130605163831.GA16410@ioremap.net>
References: <1369055799-9428-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369055799-9428-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, May 20, 2013 at 10:16:39AM -0300, Fabio Estevam (fabio.estevam@freescale.com) wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core)
> we can rely on device core for handling pinctrl, so remove 
> devm_pinctrl_get_select_default() from the driver.

Sorry for long delay - is this patch still needed to be pushed upstream?
If so, Greg, please pull it into your tree.

Thank you.

> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/w1/masters/w1-gpio.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index 46d9701..f54ece2 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -16,7 +16,6 @@
>  #include <linux/gpio.h>
>  #include <linux/of_platform.h>
>  #include <linux/of_gpio.h>
> -#include <linux/pinctrl/consumer.h>
>  #include <linux/err.h>
>  #include <linux/of.h>
>  
> @@ -78,13 +77,8 @@ static int w1_gpio_probe(struct platform_device *pdev)
>  {
>  	struct w1_bus_master *master;
>  	struct w1_gpio_platform_data *pdata;
> -	struct pinctrl *pinctrl;
>  	int err;
>  
> -	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> -	if (IS_ERR(pinctrl))
> -		dev_warn(&pdev->dev, "unable to select pin group\n");
> -
>  	if (of_have_populated_dt()) {
>  		err = w1_gpio_probe_dt(pdev);
>  		if (err < 0) {
> -- 
> 1.8.1.2
> 

-- 
	Evgeniy Polyakov
