Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaIEITQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:19:16 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43469 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIEITN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:19:13 -0400
MIME-Version: 1.0
In-Reply-To: <1409503155-23648-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409503155-23648-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 5 Sep 2014 10:19:12 +0200
Message-ID: <CACRpkdYFeAF2bKvNZr7CbR6ka7oT3BDUKJC6UkjvOb4_T5GgJQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: lantiq: Release gpiochip resources in fail case
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Crispin <blogic@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 6:39 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch releases gpiochip resources with of_gpiochip_remove
> gpiochip_remove in failure cases.
>
> CC: John Crispin <blogic@openwrt.org>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/pinctrl/pinctrl-xway.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
> index e66f4ca..d234dc2 100644
> --- a/drivers/pinctrl/pinctrl-xway.c
> +++ b/drivers/pinctrl/pinctrl-xway.c
> @@ -802,6 +802,7 @@ static int pinmux_xway_probe(struct platform_device *pdev)
>         ret = gpiochip_add(&xway_chip);
>         if (ret) {
>                 dev_err(&pdev->dev, "Failed to register gpio chip\n");
> +               of_gpiochip_remove(&xway_chip);
>                 return ret;
>         }
>
> @@ -823,6 +824,8 @@ static int pinmux_xway_probe(struct platform_device *pdev)
>         ret = ltq_pinctrl_register(pdev, &xway_info);
>         if (ret) {
>                 dev_err(&pdev->dev, "Failed to register pinctrl driver\n");
> +               gpiochip_remove(&xway_chip);
> +               of_gpiochip_remove(&xway_chip);

gpiochip_remove() already calls of_gpiochip_remove().

Yours,
Linus Walleij
