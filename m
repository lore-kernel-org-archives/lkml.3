Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3AUKtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:49:50 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:61574 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3AUKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:49:49 -0500
MIME-Version: 1.0
In-Reply-To: <1358762966-20791-24-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-24-git-send-email-thierry.reding@avionic-design.de>
Date: Mon, 21 Jan 2013 16:19:48 +0530
X-Google-Sender-Auth: uXqabDbE-SrNYzNv0T4QNwycZuE
Message-ID: <CAOh2x=nCv23SLzM6uyFKFJtcgHSuEpGcGEhf6QL7GLm+Z_RzEA@mail.gmail.com>
Subject: Re: [PATCH 23/33] pwm: Convert to devm_ioremap_resource()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 3:39 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> index 83b21d9..69a2d9e 100644
> --- a/drivers/pwm/pwm-spear.c
> +++ b/drivers/pwm/pwm-spear.c
> @@ -192,9 +192,9 @@ static int spear_pwm_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>         }
>
> -       pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
> -       if (!pc->mmio_base)
> -               return -EADDRNOTAVAIL;
> +       pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
> +       if (IS_ERR(pc->mmio_base))
> +               return PTR_ERR(pc->mmio_base);
>
>         pc->clk = devm_clk_get(&pdev->dev, NULL);
>         if (IS_ERR(pc->clk))

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
