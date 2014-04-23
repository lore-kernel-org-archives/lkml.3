Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaDWJi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:38:29 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44954 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbaDWJi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:38:26 -0400
MIME-Version: 1.0
Date: Wed, 23 Apr 2014 15:08:25 +0530
Message-ID: <CAKohpokPSVTJ5rupW8vM0btgtc9S6bWdgCdDkn6qHK5SfcGX0A@mail.gmail.com>
Subject: [Query]: hrtimers: why don't we consider hrtimers in get_next_timer_interrupt()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

File: hrtimer.c
Function: hrtimer_get_next_event()

I was looking closely at what's waking up my system and
found this piece of code:

ktime_t hrtimer_get_next_event(void)
{
        if (!hrtimer_hres_active()) {
                find next hrtimer event ....
        }
}

Which probably means that: "don't consider hrtimers for getting
next timer event if we are running ticks in high resolution mode".

And I couldn't understand why is it so?

When hres_active isn't set, we run hrtimer handlers from timer
handlers, which means that timers would be sufficient in finding
the next event and we don't need to check for hrtimers.

But when hres_active is set, hrtimers could be set to fire before
the next timer event and so we must take them into account.

I am new to this whole world of core frameworks and might be
missing something very very obvious. But its always better to
ask than to ignore and think that things are probably fine and
just shut up.

Thanks for your patience during my learning curve :)

--
viresh
