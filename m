Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3G2P7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:59:13 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44703 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3G2P7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
Date: Mon, 29 Jul 2013 17:59:08 +0200
Message-ID: <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Simon Guinot <simon.guinot@sequanux.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 11:50 AM, Simon Guinot
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
> Changes since v2:
> - Remove useless NULL setters for driver data.

Given the recent discussion with Rafael I want to have an
extended discussion of this patch.

It is my current understanding that:

- It is possible to define the whereabouts of the SuperIO
  chips using ACPI
- It is possible for developers to influence the source
  AML for the DSDT tables of these systems.
- It is the proper thing to do.
- So we should atleast support ACPI probing with the
  port-based detection as a final fallback if all else fails.

Why can I not get something like:

#include <linux/acpi.h>
(...)
static const struct acpi_device_id gpio_acpi_match[] = {
        { "FOOBAR", 0 },
        { }
};
MODULE_DEVICE_TABLE(acpi, gpio_acpi_match);

static struct platform_driver gpio_driver = {
        (...)
        .driver         = {
                 (...)
                .acpi_match_table = ACPI_PTR(gpio_acpi_match),
        },
};

?

If there is something wrong in my reasoning above, please
share it!

Yours,
Linus Walleij
