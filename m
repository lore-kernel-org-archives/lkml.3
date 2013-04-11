Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3DKIWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:22:52 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:57491 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3DKIWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <11205025.2MA5VbIUoF@ganymedes>
References: <1365439617-18816-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<14854575.YAd2OMKOy9@ganymedes>
	<5165A0FD.5030308@gmail.com>
	<11205025.2MA5VbIUoF@ganymedes>
Date: Thu, 11 Apr 2013 10:22:48 +0200
Message-ID: <CABJ1b_S_Tz9WBuO1==7ZU-fuAnYRwRZUcLCM=Zq+6tLCZyEevw@mail.gmail.com>
Subject: Re: [PATCH v7] clk: add si5351 i2c common clock driver
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: Daniel Mack <zonque@gmail.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 9:44 AM, Michal Bachraty
<michal.bachraty@streamunlimited.com> wrote:
> On Wednesday, April 10, 2013 19:27:25 Sebastian Hesselbarth wrote:
>> Hmm, is there any driver using the clock output? Does it
>> clk_prepare_enable() the clock? I tend not to mess with anything the
>> bootloader or eeprom config left disabled. It works for me, but here the
>> driver will prepare/enable the clock prior use.
>
> For my case, disabled clock outputs in bootloader are correct. I'm working on
> module board with lot of purposes. For one I need to tune frequncy, for other
> not. In some cases I can use  clk_prepare_enable. For now, I need to tune clk,
> so I can't use clk_prepare_enable. Si5351 chip has no problem with enabling
> clock output multiple times, when calling clk_set_rate. So if this feature
> will not be in driver, I need to stay with patch upon driver.

Michal,

after thinking about it, I will re-add the power-on on rate change.
Not because I
want to have a workaround for not using clk_prepare_enable() before
clk_set_rate(),
but clkout will remain disabled if you set clock-frequency by DT.
There will be no
superfluous writes to i2c resisters anyway, because clk-si5351 is
using regmap-i2c
that takes care of caching.

Sebastian
