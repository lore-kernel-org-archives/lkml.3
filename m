Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3AUK4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:56:42 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:36056 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3AUK4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:56:41 -0500
MIME-Version: 1.0
In-Reply-To: <1358762966-20791-22-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-22-git-send-email-thierry.reding@avionic-design.de>
Date: Mon, 21 Jan 2013 16:20:59 +0530
X-Google-Sender-Auth: fKlGoZLOiTBM2BH4erfe9To0npU
Message-ID: <CAOh2x==LqHHVJsjo2TtyGHSkSjQ4nBZmVUppuj6uHfM0Cj9k_Q@mail.gmail.com>
Subject: Re: [PATCH 21/33] pinctrl: Convert to devm_ioremap_resource()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 3:39 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
> index 3cf4ecd..295b349 100644
> --- a/drivers/pinctrl/spear/pinctrl-plgpio.c
> +++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
> @@ -540,11 +540,9 @@ static int plgpio_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>         }
>
> -       plgpio->base = devm_request_and_ioremap(&pdev->dev, res);
> -       if (!plgpio->base) {
> -               dev_err(&pdev->dev, "request and ioremap fail\n");

can we keep this as is?

> -               return -ENOMEM;
> -       }
> +       plgpio->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(plgpio->base))
> +               return PTR_ERR(plgpio->base);
>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
