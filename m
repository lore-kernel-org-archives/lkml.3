Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3CFKiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:38:17 -0500
Received: from [212.90.139.82] ([212.90.139.82]:36302 "EHLO smtp2.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab3CFKiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:38:16 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.884
From: Lars Poeschel <poeschel@lemonage.de>
To: Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] gpio: viperboard: Remove duplicate code to set gpio->gpiob_val
Date: Wed, 6 Mar 2013 11:38:21 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
References: <1362486116.3660.1.camel@phoenix>
In-Reply-To: <1362486116.3660.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303061138.21776.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013 at 13:21:56, Axel Lin wrote:
> Set it once is enough, and it's done in vprbrd_gpiob_set() which is called
> by vprbrd_gpiob_direction_output().
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thank you!

Tested-and-Acked-by: Lars Poeschel <poeschel@lemonage.de>

> ---
>  drivers/gpio/gpio-viperboard.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-viperboard.c
> b/drivers/gpio/gpio-viperboard.c index 59d7239..095ab14 100644
> --- a/drivers/gpio/gpio-viperboard.c
> +++ b/drivers/gpio/gpio-viperboard.c
> @@ -380,10 +380,6 @@ static int vprbrd_gpiob_direction_output(struct
> gpio_chip *chip, struct vprbrd *vb = gpio->vb;
> 
>  	gpio->gpiob_out |= (1 << offset);
> -	if (value)
> -		gpio->gpiob_val |= (1 << offset);
> -	else
> -		gpio->gpiob_val &= ~(1 << offset);
> 
>  	mutex_lock(&vb->lock);

