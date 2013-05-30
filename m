Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3E3SCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:02:15 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58141 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3E3SCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:02:09 -0400
MIME-Version: 1.0
In-Reply-To: <1369420342-27085-4-git-send-email-rvaswani@codeaurora.org>
References: <1369420342-27085-1-git-send-email-rvaswani@codeaurora.org>
	<1369420342-27085-4-git-send-email-rvaswani@codeaurora.org>
Date: Thu, 30 May 2013 20:02:08 +0200
Message-ID: <CACRpkdaf81BBGKaDwjMW=AWe+nrstbyLoYyTHFqfXqRnOmmNVA@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 8:32 PM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:

> This cleans up the gpio-msm-v2 driver of all the global define usage.
> The number of gpios are now defined in the device tree. This enables
> adding irqdomain support as well.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>

Good clean-up so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

But here is an unrelated hint for later refactoring:

> +       msmgpio: gpio@800000 {
> +               compatible = "qcom,msm-gpio";
> +               reg = <0x00800000 0x1000>;
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +               ngpio = <173>;
> +               interrupts = <0 32 0x4>;

If you switch the dts[i] files to use the C preprocessor include syntax
you can change all interrupts to look like so:

#include <dt-bindings/interrupt-controller/irq.h>

interrupts = <0 32 IRQ_TYPE_LEVEL_HIGH>;

Which is helpful.

Yours,
Linus Walleij
