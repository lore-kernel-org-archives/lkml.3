Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3HGQac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:30:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:53036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3HGQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:30:31 -0400
Message-ID: <52027623.20807@linutronix.de>
Date: Wed, 07 Aug 2013 18:30:27 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: Re: [PATCH] clocksource: add an "menu" item to Kconfig
References: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de> <520273FB.3030103@linaro.org>
In-Reply-To: <520273FB.3030103@linaro.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:21 PM, John Stultz wrote:
> On 08/07/2013 03:56 AM, Sebastian Andrzej Siewior wrote:
>> This patch adds a menu item to clocksource' Kconfig file. Without it the
>> changeable items look somehow lost in the main drivers' menu
> 
> So I'd like to push back on this a bit and ask why we need user-visible
> clocksource config options?

There was one visible Option if I remember correctly. I added two and
was wondering once I found them. I do have a PCI card which provides a
clock source and clock events device. So I assumed select <m|y> would
be doable.

> I'm much prefer the platform options select the needed clocksources, and
> not leave it up to the user (who really doesn't want to go digging
> around to find the clocksource sub-menu under drivers, and scan a list
> of 100 options that aren't possible on their hardware).
> 
> For an example of what I consider bad behavior here, see the RTC driver
> directory - at a certain point they just become hashes: "Oh no.. you
> selected rtc-387aae6fd, on your hardware, you need rtc-adfb8e5".
> 
> It really just seems like it forces more unnecessary options on the user
> and more ways to build a kernel that won't boot.
> 
> I do get you're trying to fix up the bad situation, caused by
> user-prompts slipping into the Kconfig.

Yes, that is fine. That PCI device is divided into multiple devices so
once it is enabled I could use "select" for required clock source.

> But I might prefer a patch closer to whats below.

Okay.

> 
> thanks
> -john


Sebastian

