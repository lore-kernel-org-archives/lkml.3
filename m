Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3GTUkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:40:45 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:59453 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3GTUkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <1374055212-985-1-git-send-email-simon.guinot@sequanux.org>
References: <1374055212-985-1-git-send-email-simon.guinot@sequanux.org>
Date: Sat, 20 Jul 2013 22:40:43 +0200
Message-ID: <CACRpkdbPJ67PFOBLExW8kaeQpxxXcuC0xV7N6TwYDdzcTu44Kg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:00 PM, Simon Guinot
<simon.guinot@sequanux.org> wrote:

> This patch adds support for the GPIOs found on the Fintek super-I/O
> chips F71882FG and F71889F.
>
> A super-I/O is a legacy I/O controller embedded on x86 motherboards. It
> is used to connect the low-bandwidth devices. Among others functions the
> F71882FG/F71889F provides: a parallel port, two serial ports, a keyboard
> controller, an hardware monitoring controller and some GPIO pins.
>
> Note that this super-I/Os are embedded on some Atom-based LaCie NASes.
> The GPIOs are used to control the LEDs and the hard drive power.
>
> Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
> ---
> Linus, I am waiting for your feedback about the Super-I/O device
> detection. Then this part is unchanged since the previous version.
> Else I think I have addressed your other concerns.
>
> Changes since v1:
> - Enhance the commit message by describing what is a Super-I/O.
> - Use self-explanatory names for the GPIO register macros.
> - Add a comment to explain the platform device and driver registration.
> - Fix gpio_get when GPIO is configured in input mode. I only had
>   the hardware to check this mode recently...

This is mostly fine.

> +static int f7188x_gpio_probe(struct platform_device *pdev)
> +{
(...)
> +       platform_set_drvdata(pdev, data);
(...)
> +       platform_set_drvdata(pdev, NULL);
(...)
> +static int f7188x_gpio_remove(struct platform_device *pdev)
(...)
> +       platform_set_drvdata(pdev, NULL);

We don't need to set drvdata to NULL I think, there were
lots of patches addressing this last merge window by Jingoo Han,
see e.g. commit 1cdd8d52ecbedbce1cbac063aa5715810a228ab3
so please get rid of the NULL setters.

Yours,
Linus Walleij
