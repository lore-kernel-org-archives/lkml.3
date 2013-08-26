Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3HZIdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:33:42 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52866 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab3HZIdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:33:39 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] pinctrl: rockchip: Simplify pin_to_bank equation
Date: Mon, 26 Aug 2013 10:33:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
References: <1377244140.24387.1.camel@phoenix>
In-Reply-To: <1377244140.24387.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308261033.35541.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 23. August 2013, 09:49:00 schrieb Axel Lin:
> If (b->pin_base + b->nr_pins - 1) < pin is true, pin >= b->pin_base is
> always true because b->nr_pins is never less than 0.
> Thus this patch simplify the equation.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  drivers/pinctrl/pinctrl-rockchip.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> b/drivers/pinctrl/pinctrl-rockchip.c index 319a64a..ea27806 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -186,8 +186,7 @@ static struct rockchip_pin_bank *pin_to_bank(struct
> rockchip_pinctrl *info, {
>  	struct rockchip_pin_bank *b = info->ctrl->pin_banks;
> 
> -	while ((pin >= b->pin_base) &&
> -			((b->pin_base + b->nr_pins - 1) < pin))
> +	while (pin >= (b->pin_base + b->nr_pins))
>  		b++;
> 
>  	return b;

