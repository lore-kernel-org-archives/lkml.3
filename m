Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3AUKwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:52:23 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61919 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3AUKwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:52:22 -0500
MIME-Version: 1.0
In-Reply-To: <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
Date: Mon, 21 Jan 2013 16:22:21 +0530
X-Google-Sender-Auth: ym3qKvSMU9QAbBawGY2aqfKF4Tk
Message-ID: <CAOh2x=ne_Oe7V=BzjQJtuPv20syorLTq-C89aKQDo4JK78Y8YA@mail.gmail.com>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 3:39 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> diff --git a/drivers/gpio/gpio-spear-spics.c b/drivers/gpio/gpio-spear-spics.c
> index 5f45fc4..7a4bf7c 100644
> --- a/drivers/gpio/gpio-spear-spics.c
> +++ b/drivers/gpio/gpio-spear-spics.c
> @@ -140,11 +140,9 @@ static int spics_gpio_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>         }
>
> -       spics->base = devm_request_and_ioremap(&pdev->dev, res);
> -       if (!spics->base) {
> -               dev_err(&pdev->dev, "request and ioremap fail\n");

can we keep it as is?

> -               return -ENOMEM;
> -       }
> +       spics->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(spics->base))
> +               return PTR_ERR(spics->base);
>


Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
