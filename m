Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaAOJ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:28:17 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46915 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaAOJ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:28:14 -0500
MIME-Version: 1.0
In-Reply-To: <1389700739-3696-7-git-send-email-wsa@the-dreams.de>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
	<1389700739-3696-7-git-send-email-wsa@the-dreams.de>
Date: Wed, 15 Jan 2014 10:28:13 +0100
Message-ID: <CACRpkdYymB4i7Ju5MMNXWVe5nB6_NbWHwrPbOK2KeT0Ji-RzQg@mail.gmail.com>
Subject: Re: [PATCH 7/7] drivers/gpio: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 12:58 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>
> Should go via subsystem tree
>
>  drivers/gpio/gpio-davinci.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 84be701..a5e1a56 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -172,11 +172,6 @@ static int davinci_gpio_probe(struct platform_device *pdev)
>         }
>
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res) {
> -               dev_err(dev, "Invalid memory resource\n");
> -               return -EBUSY;
> -       }
> -
>         gpio_base = devm_ioremap_resource(dev, res);
>         if (IS_ERR(gpio_base))
>                 return PTR_ERR(gpio_base);

Acked-by: Linus Walleij <linus.walleij@linaro.org>

The DaVinci maintainers are queuing GPIO patches for their driver
for this merge window, so requesting them to apply this patch.

Yours,
Linus Walleij
