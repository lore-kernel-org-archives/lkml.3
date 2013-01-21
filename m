Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3AUKua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:50:30 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:49383 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3AUKu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:50:29 -0500
MIME-Version: 1.0
In-Reply-To: <1358762966-20791-25-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-25-git-send-email-thierry.reding@avionic-design.de>
Date: Mon, 21 Jan 2013 16:20:28 +0530
X-Google-Sender-Auth: dmyvX_woi98EaBkb2Uw5nWy-F_E
Message-ID: <CAOh2x=nQga2umyMMdZ0R2sFj0iY2p3wXVGQ62yV24cVSoHTCPA@mail.gmail.com>
Subject: Re: [PATCH 24/33] rtc: Convert to devm_ioremap_resource()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 3:39 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
> index c2121b5..a18c319 100644
> --- a/drivers/rtc/rtc-spear.c
> +++ b/drivers/rtc/rtc-spear.c
> @@ -385,11 +385,9 @@ static int spear_rtc_probe(struct platform_device *pdev)
>                 return status;
>         }
>
> -       config->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
> -       if (!config->ioaddr) {
> -               dev_err(&pdev->dev, "request-ioremap fail\n");

can we keep it as is?

> -               return -ENOMEM;
> -       }
> +       config->ioaddr = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(config->ioaddr))
> +               return PTR_ERR(config->ioaddr);
>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
