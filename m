Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbbAVVIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:08:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:33511 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbbAVVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:08:18 -0500
Date: Thu, 22 Jan 2015 22:07:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xunlei Pang <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v2 3/3] time: clocksource: Add a comment to
 CLOCK_SOURCE_SUSPEND_NONSTOP
In-Reply-To: <1421928077-4698-3-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1501222202420.5526@nanos>
References: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org> <1421928077-4698-3-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Xunlei Pang wrote:
> When doing timekeeping_resume(), if the nonstop clocksource
> wraps back, "cycle_delta" will miss the wrap time.
> 
> It's hard to determine the right CLOCKSOURCE_MASK(xxx) or
> something to add code for inspecting such behavior, and we
> don't have many existent nonstop clocksources, so just add
> a comment to indicate that if have this flag set, people
> are aware that this nonstop clocksource won't wrap back
> during system suspend/resume.

-ENOPARSE

What has the CLOCKSOURCE_MASK() to do with this and why is the fact
relevant, that we only have a few suspend_nonstop clock sources?

> +
> +/*
> + * When setting this flag, you're also supposed to mean that it doesn't
> + * wrap back during system suspend/resume. See timekeeping_resume().

-ENOPARSE

I guess what you want to say here is:

/*
 * clocksource continues to run during suspend and is guaranteed not to
 * wrap around during long suspend periods.
 */

> + */
>  #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80

Thanks,

	tglx
