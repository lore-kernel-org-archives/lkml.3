Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3GEKGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:06:01 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60790 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab3GEKGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:06:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307042211420.11637@ionos.tec.linutronix.de>
References: <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com>
	<1372940383-5957-1-git-send-email-jonas.jensen@gmail.com>
	<alpine.DEB.2.02.1307042211420.11637@ionos.tec.linutronix.de>
Date: Fri, 5 Jul 2013 12:05:59 +0200
Message-ID: <CACmBeS03Xfo7DyyYUbpBaO8TeR3g8BTPzcoOzQayk40k1soFzA@mail.gmail.com>
Subject: Re: [PATCH v5] ARM: clocksource: add support for MOXA ART SoCs
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 July 2013 23:42, Thomas Gleixner <tglx@linutronix.de> wrote:
> You just modify bits on the "cache" variable. though you are not
> caching it. As it seems to work it looks like this register simply can
> be written with constants.

I agree, the global "cache" variable wasn't very good. The only good thing, that
it eliminated all TIMER_CR reads in moxart_clkevt_next_event.

Yes it could be written with constants, and it wouldn't be so bad, because in
this case so few need to be set. If more constants were set from init
the benefit
would be more clear.

>> +     timereg_cache = readl(base + TIMER_CR) | TIMEREG_CR_2_ENABLE;
>
> Why are you reading that back? You know excactly which of the timers
> you are using and none of those should be enabled before you reach
> that code. If it one of them is enabled by the boot loader you better
> disable it in this init function.

Removed. All timers except TIMER2 should be disabled in init.

> Now if you disable all of those timers and just use a known set, then
> you can do without a pseudo cache variable and just write constants
> into the control register, right ?

Yes, please take a look at v6.


Best regards,
Jonas
