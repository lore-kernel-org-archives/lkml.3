Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbbAORD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:03:27 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37219 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbAORDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:03:24 -0500
MIME-Version: 1.0
In-Reply-To: <1421156505-16600-3-git-send-email-semen.protsenko@globallogic.com>
References: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
	<1421156505-16600-3-git-send-email-semen.protsenko@globallogic.com>
Date: Thu, 15 Jan 2015 18:03:23 +0100
Message-ID: <CACRpkdbH3xD0LbmkZB-ewc8rzhFmD=2FRMWA_L=Wrv9OxagedQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpio: max732x: Rewrite IRQ code to use irq_domain API
From: Linus Walleij <linus.walleij@linaro.org>
To: Semen Protsenko <semen.protsenko@globallogic.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Marc Zyngier <maz@misterjones.org>,
        Grygorii Strashko <grygorii.strashko@globallogic.com>,
        Illia Smyrnov <illia.smyrnov@globallogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 2:41 PM, Semen Protsenko
<semen.protsenko@globallogic.com> wrote:

> Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>

This makes the code *so* much better so patch applied, naturally.

But...

>  config GPIO_MAX732X
>         tristate "MAX7319, MAX7320-7327 I2C Port Expanders"
>         depends on I2C
> +       select IRQ_DOMAIN

The most modern way would be to take another step and convert the
driver to GPIOLIB_IRQCHIP by stating

select GPIOLIB_IRQCHIP

here.

If you look at other drivers using GPIOLIB_IRQCHIP on an
i2c expander, say gpio-stmpe.c or gpio-tc3589x.c, you
can get a grip on how that works.

So please follow up with a patch converting the driver to
GPIOLIB_IRQCHIP on top of these patches :) if you
have time.

Yours,
Linus Walleij
