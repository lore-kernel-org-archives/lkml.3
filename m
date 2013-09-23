Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3IWQxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:53:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:2963 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3IWQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:53:30 -0400
Message-ID: <52407208.1060300@atmel.com>
Date: Mon, 23 Sep 2013 18:53:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-pcmcia@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 4/7] pcmcia: at91_cf: fix deferred probe from __init
References: <20130923134028.GF21013@sirena.org.uk> <1379946452-25649-1-git-send-email-jhovold@gmail.com> <1379946452-25649-5-git-send-email-jhovold@gmail.com>
In-Reply-To: <1379946452-25649-5-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/2013 16:27, Johan Hovold :
> Move probe out of __init section and don't use platform_driver_probe
> which cannot be used with deferred probing.
>
> Since commit e9354576 ("gpiolib: Defer failed gpio requests by default")
> this driver might return -EPROBE_DEFER if a gpio_request fails.
>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks Johan.

> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>   drivers/pcmcia/at91_cf.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
> index b8f5acf..de24232 100644
> --- a/drivers/pcmcia/at91_cf.c
> +++ b/drivers/pcmcia/at91_cf.c
> @@ -245,7 +245,7 @@ static int at91_cf_dt_init(struct platform_device *pdev)
>   }
>   #endif
>
> -static int __init at91_cf_probe(struct platform_device *pdev)
> +static int at91_cf_probe(struct platform_device *pdev)
>   {
>   	struct at91_cf_socket	*cf;
>   	struct at91_cf_data	*board = pdev->dev.platform_data;
> @@ -354,7 +354,7 @@ fail0a:
>   	return status;
>   }
>
> -static int __exit at91_cf_remove(struct platform_device *pdev)
> +static int at91_cf_remove(struct platform_device *pdev)
>   {
>   	struct at91_cf_socket	*cf = platform_get_drvdata(pdev);
>
> @@ -404,14 +404,13 @@ static struct platform_driver at91_cf_driver = {
>   		.owner		= THIS_MODULE,
>   		.of_match_table = of_match_ptr(at91_cf_dt_ids),
>   	},
> -	.remove		= __exit_p(at91_cf_remove),
> +	.probe		= at91_cf_probe,
> +	.remove		= at91_cf_remove,
>   	.suspend	= at91_cf_suspend,
>   	.resume		= at91_cf_resume,
>   };
>
> -/*--------------------------------------------------------------------------*/
> -
> -module_platform_driver_probe(at91_cf_driver, at91_cf_probe);
> +module_platform_driver(at91_cf_driver);
>
>   MODULE_DESCRIPTION("AT91 Compact Flash Driver");
>   MODULE_AUTHOR("David Brownell");
>


-- 
Nicolas Ferre
