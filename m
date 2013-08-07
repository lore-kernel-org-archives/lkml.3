Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3HGQVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:21:21 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33365 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab3HGQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:21:18 -0400
Message-ID: <520273FB.3030103@linaro.org>
Date: Wed, 07 Aug 2013 09:21:15 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: Re: [PATCH] clocksource: add an "menu" item to Kconfig
References: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:56 AM, Sebastian Andrzej Siewior wrote:
> This patch adds a menu item to clocksource' Kconfig file. Without it the
> changeable items look somehow lost in the main drivers' menu

So I'd like to push back on this a bit and ask why we need user-visible 
clocksource config options?

I'm much prefer the platform options select the needed clocksources, and 
not leave it up to the user (who really doesn't want to go digging 
around to find the clocksource sub-menu under drivers, and scan a list 
of 100 options that aren't possible on their hardware).

For an example of what I consider bad behavior here, see the RTC driver 
directory - at a certain point they just become hashes: "Oh no.. you 
selected rtc-387aae6fd, on your hardware, you need rtc-adfb8e5".

It really just seems like it forces more unnecessary options on the user 
and more ways to build a kernel that won't boot.

I do get you're trying to fix up the bad situation, caused by 
user-prompts slipping into the Kconfig.

But I might prefer a patch closer to whats below.

thanks
-john


diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index b7b9b04..b3050db 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -57,14 +57,14 @@ config CLKSRC_NOMADIK_MTU_SCHED_CLOCK
  	  Use the Multi Timer Unit as the sched_clock.
  
  config CLKSRC_DBX500_PRCMU
-	bool "Clocksource PRCMU Timer"
+	bool
  	depends on UX500_SOC_DB8500
  	default y
  	help
  	  Use the always on PRCMU Timer as clocksource
  
  config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
-	bool "Clocksource PRCMU Timer sched_clock"
+	bool
  	depends on (CLKSRC_DBX500_PRCMU && !CLKSRC_NOMADIK_MTU_SCHED_CLOCK)
  	default y
  	help


