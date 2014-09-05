Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaIEIW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:22:27 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58745 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbaIEIW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <1409484115-1974-3-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
	<1409484115-1974-3-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 5 Sep 2014 10:22:25 +0200
Message-ID: <CACRpkdY1Oebw8P4gnR7RORakj-vG+hG+1yXF0tpDaaKZ6z=hEw@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: at91: Fix failure path in at91_gpio_probe path
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 1:21 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This fixes the whole error handling in probe function by capturing and
> returning error values on kernel function like clk_prepare,
> clk_enable, gpiochip_add etc.
>
> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/pinctrl/pinctrl-at91.c |   20 +++++++++++++-------
>  1 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 480460d..7abe683 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -1578,16 +1578,19 @@ static int at91_gpio_probe(struct platform_device *pdev)
>         at91_chip->clock = devm_clk_get(&pdev->dev, NULL);
>         if (IS_ERR(at91_chip->clock)) {
>                 dev_err(&pdev->dev, "failed to get clock, ignoring.\n");
> +               ret = IS_ERR(at91_chip->clock);

No. IS_ERR() returns a bool.

You want to use PTR_ERR().

Yours,
Linus Walleij
