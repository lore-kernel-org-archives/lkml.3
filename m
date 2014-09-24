Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaIXJKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:10:48 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:59717 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaIXJKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <1410790185-31101-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1410790185-31101-1-git-send-email-mika.westerberg@linux.intel.com>
	<1410790185-31101-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 24 Sep 2014 11:10:39 +0200
Message-ID: <CACRpkdaTfnsOv4htpE+3mxRWFeSd6TtbQbb48oPFEvwE+WHQCw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gpio: Add support for Intel Cherryview/Braswell
 GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>, Ning Li <ning.li@intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 4:09 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> From: Ning Li <ning.li@intel.com>
>
> This driver supports the GPIO controllers found in newer Intel SoCs like
> Cherryview and Braswell.
>
> Signed-off-by: Ning Li <ning.li@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
(...)
> +#define FAMILY0_PAD_REGS_OFF   0x4400
> +#define FAMILY_PAD_REGS_SIZE   0x400
> +#define MAX_FAMILY_PAD_GPIO_NO 15

Pad registers...

> +static const char * const north_pads[] = {
> +       "GPIO_DFX_0",
> +       "GPIO_DFX_3",
> +       "GPIO_DFX_7",
> +       "GPIO_DFX_1",
> +       "GPIO_DFX_5",
> +       "GPIO_DFX_4",
> +       "GPIO_DFX_8",
> +       "GPIO_DFX_2",
> +       "GPIO_DFX_6",

And then even naming them and stuff.

This is almost a schoolbook definition of stuff that pertains
to the pin control subsystem rather than GPIO, and this
info in particular shall be encoded in the .pins field of
the struct pinctrl_desc. Which is where we name pins.

> +               switch ((ctrl0 & CV_GPIO_CFG_MASK) >> 8) {
> +               case 0:
> +                       dir = "in out";
> +                       break;
> +               case 1:
> +                       dir = "   out";
> +                       break;
> +               case 2:
> +                       dir = "in";
> +                       break;
> +               case 3:
> +                       dir = "HiZ";
> +                       break;

And here there is even pin config like HiZ, which is in the kernel
called PIN_CONFIG_BIAS_HIGH_IMPEDANCE with generic
pin config.

In short it seems the driver is written by someone who has never
heard of pin control or doesn't realize that this is exactly what
pin control is about.

Read Documentation/pinctrl.txt and rewrite the entire driver to
use pin control, and generic pin config like everyone else.

Yours,
Linus Walleij
