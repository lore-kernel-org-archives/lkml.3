Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3H3Iky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:40:54 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33160 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3H3Ikw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAJxxZ0PmMCLWWRbXcOWgkkq3SjhBxc=3vu1UcM_DrmtpP3XHhw@mail.gmail.com>
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
	<52150AD9.3040808@wwwdotorg.org>
	<CAJxxZ0O77bgP8_rkRm-EgjAJ45SY2Pd3AGVSMhFxbsfNUmiqGg@mail.gmail.com>
	<CACRpkdYF4bD2ho=mLokdPfd0hKnNvGKbGRiiM5=UZv_e7+AY4g@mail.gmail.com>
	<CAJxxZ0PmMCLWWRbXcOWgkkq3SjhBxc=3vu1UcM_DrmtpP3XHhw@mail.gmail.com>
Date: Fri, 30 Aug 2013 10:40:51 +0200
Message-ID: <CACRpkdbYB175wXYscP4Z=FQe7r9EzLoM+V+tWMK9YpNPFqH1wg@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:31 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> On Thu, Aug 29, 2013 at 4:12 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> This is similar to the situation in the pinctrl-nomadik.c driver,
>> where the pinctrl portions wait for the GPIO devices to instantiate
>> before proceeding to probe "on top" of the GPIO blocks, using
>> the latter to get to the registers.
>>
>> I am not sure we have found the best way to sort out this
>> type of system, let's see what we can come up with.
>
> In the blackfin pinctrol-adi2 driver, I probe all gpio devices
> independently after all logic pinctrl devices. When one gpio device is
> probed, it can get its pinctrl device name from its platform data and
> add its gpio range into the pinctrl device via
> gpiochip_add_pin_range(). The gpio device don't need to know anything
> else about its pinctrl device.

This is ideal in the situation when there is a clear separation
between the GPIO and pin control (muxing, biasing)
registers. So you're doing the right thing.

Yours,
Linus Walleij
