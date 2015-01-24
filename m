Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbbAXRHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:07:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:40837 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbAXRHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:07:53 -0500
Date: Sat, 24 Jan 2015 18:07:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xunlei Pang <pang.xunlei@linaro.org>
cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v2 3/3] time: clocksource: Add a comment to
 CLOCK_SOURCE_SUSPEND_NONSTOP
In-Reply-To: <CADcy93UD1EHiHLsgCPjODZMu1fBpKhOXuN=4Egwu6gB2UZX0+w@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501241746210.5526@nanos>
References: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org> <1421928077-4698-3-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1501222202420.5526@nanos> <CADcy93UD1EHiHLsgCPjODZMu1fBpKhOXuN=4Egwu6gB2UZX0+w@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015, Xunlei Pang wrote:

> Before this, I tried to add some code to catch such problem at the
> time of registering the clocksource, like using the
> CLOCKSOURCE_MASK(), for example 64bit counter will never wrap for
> us. But there may be other values like CLOCKSOURCE_MASK(56), I just
> can't figure out exactly how to do this judge.

I don't think there is a good way to do so. Registration time is the
wrong place anyway because the problem depends on:

 - The width of the counter
 - The frequency of the counter

The frequency of the counter might even change after registration. Now
add the unknown duration of the suspend to the picture and you're
completely lost.

All we can do is provide information about the actual wraparound time,
if the CLOCK_SOURCE_SUSPEND_NONSTOP flag is set and the wraparound
time is less than some reasonable margin.

Thanks,

	tglx




