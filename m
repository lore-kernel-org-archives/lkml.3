Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3AQLGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:06:37 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60202 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3AQLGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:06:35 -0500
MIME-Version: 1.0
In-Reply-To: <50F127A4.907@free-electrons.com>
References: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
	<1357317909-12458-2-git-send-email-maxime.ripard@free-electrons.com>
	<CACRpkda0yhVvCW9edWBi3XusfS4NaiWqKsoCfLpT9+X5iO-GXg@mail.gmail.com>
	<50F127A4.907@free-electrons.com>
Date: Thu, 17 Jan 2013 12:06:33 +0100
Message-ID: <CACRpkdYK2GN_mhghhHHM+qqZ_tzy2ncu8Rm0Q7T2cagxaj7LUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 10:06 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

>> Use gpiochip_add_pin_range() from the GPIO driver.
>>
>> An example is provided in
>> drivers/pinctrl/pinctrl-coh901.c
>
> Ok, will do. But we need to find a way to share the pins arrays between
> the pinctrl and gpio drivers then.
>
> Maybe add a pinctrl-sunxi-pins.h file? or merge the pinctrl and gpio
> drivers?
>
> I'm kind of reluctant to merging the drivers into one single messy file,
> but if that's the way to go, fine.

Well, does it have to be that messy?

You can merge it different ways.

For example there is *no* need to have two different device driver
structs and two probe functions, right?

Just one device named pinctrl that has one state container and
one single dd and probe function. That makes everything sooo
much easier I think.

Just register both a pinctrl and GPIO interface (in that order).

See the recent pinctrl-abx500.c submission for an example on
how to do this.

Yours,
Linus Walleij
