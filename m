Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3F0KSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:18:17 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65217 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0KSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130626131543.GD7095@ab42.lan>
References: <1372169952-22439-1-git-send-email-linus.walleij@stericsson.com>
	<20130626131543.GD7095@ab42.lan>
Date: Thu, 27 Jun 2013 12:18:15 +0200
Message-ID: <CACRpkdbyEQ+5LD2LYPerMHeL-NGiaWrd6ugyM+FdeSRCb2BxjA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: elaborate a bit on arrangements in doc
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:15 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> In my experience, in hardware engineering terminology, GPIO/General
> Purpose I/O just means a physical pad macro cell which can be
> dynamically configured in different modes, e.g. as an input or as an
> output, as an open drain driver etc. This configuration is done through
> hardware signals and controlled by digital logic. This logic might
> either be a GPIO controller or some other hardware block, e.g. an I2C
> controller block.

This is what this patch is trying to hash out. Have you seen this
presentation I did a while back?
http://www.df.lth.se/~triad/papers/pincontrol.pdf

> Hardware GPIOs have nothing to do with the concept of GPIOs from the
> Linux kernel point of view

That is unfortunately a bit of HW engineering terminology problem.
It took some months before we came up with the three non-overlapping
(well) sets of "GPIO", "pin configuration" and "pin multiplexing" to sort
these things into three different buckets.

And this entire section in Documentation/pinctrl.txt is trying to explain
this to the kernel developer.

> In some cases, both modes are combined, e.g. one can imagine an SPI
> interface where the output levels are driven from an SPI controller
> hardware block and other parameters such as the drive strength or
> integrated pull-up/pull-down resistors are controlled through some
> independent mechanism.

This is the case on the Nomadik and I think many other pin controllers.

But on the U300, the output line is controlled by two things at the
time!

> The parameters controlled through that
> independent mechanism are sometimes referred to as the GPIO mode of the
> pin.

Yes...

Yours,
Linus Walleij
