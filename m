Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3IWSG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:06:29 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54739 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3IWSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:06:26 -0400
MIME-Version: 1.0
In-Reply-To: <5240117C.8060300@nvidia.com>
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
	<1379680214-9143-4-git-send-email-ldewangan@nvidia.com>
	<CACRpkdbJ6N-5RET+cmF=14jKVDnuAZtZwjcKym75ySER2gCpBQ@mail.gmail.com>
	<524001F3.3060602@nvidia.com>
	<CACRpkdYVTdh3+ayy96D4=iNO6ZASfTfeQOHF9vdoPjfLDCtB5Q@mail.gmail.com>
	<5240117C.8060300@nvidia.com>
Date: Mon, 23 Sep 2013 20:06:25 +0200
Message-ID: <CACRpkdYY2tfU4-E2DdoUUW4K04H08KL70JVp3ZgqW-=RFwh+Aw@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH V2 3/5] gpio: add support for AMS AS3722 gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:01 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Ok, I was thinking that we should not call gpiochip_add() from the pin
> control driver in any new driver

No that is not the case.

There are many combined pinctrl+GPIO drivers that register
both pinctrl devices and gpio_chip and also irq_chip.

When the driver and hardware does multiple things like that
in the same register range it is usually best to put the combined
driver in drivers/pinctrl.

> So this gpio driver can be moved now to the pincntrl folder and can use
> pincontrol and gpio framework.

Thanks!

Yours,
Linus Walleij
