Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3K2U3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:29:40 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62529 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab3K2U3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
References: <1385651945-22355-1-git-send-email-jonas.jensen@gmail.com>
	<1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
Date: Fri, 29 Nov 2013 21:29:37 +0100
Message-ID: <CACRpkdZbLJh-qDtEhA1Q4X9ABDtv5XTtd9-CkF2LTwzKnDbguA@mail.gmail.com>
Subject: Re: [PATCH v7] gpio: Add MOXA ART GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:11 PM, Jonas Jensen <jonas.jensen@gmail.com> wrote:

> Add GPIO driver for MOXA ART SoCs.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

OK this v6 version is looking *really good* so I have
applied it, couldn't hesitate.

> +static struct gpio_chip moxart_template_chip = {
> +       .label                  = "moxart-gpio",
> +       .request                = moxart_gpio_request,
> +       .free                   = moxart_gpio_free,
> +       .direction_input        = moxart_gpio_direction_input,
> +       .direction_output       = moxart_gpio_direction_output,
> +       .set                    = moxart_gpio_set,
> +       .get                    = moxart_gpio_get,
> +       .base                   = 0,
> +       .ngpio                  = 32,
> +       .can_sleep              = 0,
> +};

No need to initialized unused fields to zero, that is by
default. But no big deal.

> +static const struct of_device_id moxart_gpio_match[] = {
> +       { .compatible = "moxa,moxart-gpio" },
> +       { }
> +};

This vendor prefix does not exist in
Documentation/devicetree/bindings/vendor-prefixes.txt
Please send a follow-up patch adding it and I can merge
that through the GPIO tree as well.

Yours,
Linus Walleij
