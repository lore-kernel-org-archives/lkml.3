Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaDYJ36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:29:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49143 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaDYJ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAD6h2NQ4XdpE+HnTVpuSE4jW3-5_UqJmEJJcAkpD3xxqJKy3aA@mail.gmail.com>
References: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
	<CACRpkdbzoPNEEJ6UbisqHOiRwuxEb6XSrDL=MiUmDPgyY=rVuw@mail.gmail.com>
	<CAD6h2NQ4XdpE+HnTVpuSE4jW3-5_UqJmEJJcAkpD3xxqJKy3aA@mail.gmail.com>
Date: Fri, 25 Apr 2014 11:29:49 +0200
Message-ID: <CACRpkdb5bRK6n_-Rpr1WDG5H_C9WDVuLT+sop2_9hR8TW4N3fg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pl061: get gpio base from alias id
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, Xu Wei <xuwei5@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 2:27 AM, Haojian Zhuang
<haojian.zhuang@linaro.org> wrote:

> Go it. But the gpio sysfs interface is using the gpio name with an
> internal number. It'll make developer confusion since it's different
> from datasheet
> or schematics. Is there any plan to remove the confusion?

First I am as always very suspicious about the sysfs interface
since it is often used for madness like reimplementing
leds-gpio.c, gpio_keys.c, extcon-gpio.c, gpio-regulator.c
spi-gpio.c, w1-gpio.c or gpio_wdt.c in userspace for no
good reason when the kernel should handle it.

Yet there are exceptions where it's actually warranted.

There is a possibility to set a label on the gpio line,
so this should be used.

C.f.
commit 781f6d710d4482eab05cfaad50060a0ea8c0e4e0
"gpio: generic: Add label to platform data"

Something like this is needed in this and other drivers
needing to label its GPIO lines. It's much like how we name
all pins in a pin controller really.

I don't exactly know how we should achieve the same
for labels to offsets in any given gpio_chip using
some generic device tree labels for example, but I
imagine it could be implemented in a generic fashion?

Describing the names of gpio lines should be quite
obvious hardware description suitable for the device
tree.

Yours,
Linus Walleij
