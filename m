Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaAWIUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:20:22 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47146 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaAWIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:20:20 -0500
MIME-Version: 1.0
In-Reply-To: <1390349404-23326-1-git-send-email-markus.mayer@linaro.org>
References: <1390349404-23326-1-git-send-email-markus.mayer@linaro.org>
Date: Thu, 23 Jan 2014 09:20:19 +0100
Message-ID: <CACRpkdbgS3DjG+z79VV_-UUZ+t3DbZM1rxX+pHhuXv6WOxOW6Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: bcm281xx: Fix parameter name for GPIO_CONTROL macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Linaro Patches <patches@linaro.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 1:10 AM, Markus Mayer <markus.mayer@linaro.org> wrote:

> The GPIO_CONTROL macro returns the control register offset when given a
> GPIO number.
>
> Update the argument name in the macro to reflect that it takes in a
> GPIO number and not a bank.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
(...)
> +/* There is a GPIO control register for each GPIO */
> +#define GPIO_CONTROL(gpio)                     (0x00000100 + ((gpio) << 2))

Technically I prefer naming this parameter "offset" rather than
"gpio" as it is the offset of a GPIO line in *this* very GPIO
HW block rather than a GPIO number from the global
GPIO number space.

But it's no big deal, so patch applied.

Yours,
Linus Walleij
