Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaBUR4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:56:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:42633 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbaBUR4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:56:07 -0500
Message-Id: <20140221173936.583477951@linutronix.de>
User-Agent: quilt/0.60-1
Date: Fri, 21 Feb 2014 17:56:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: [RFC patch 0/5] hrtimers: Add deferrable mode
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deferrable timers are beneficial for power saving. They behave like
standard timers except that their expiry can be delayed up to the
expiry of the next non deferred timer. That prevents them from waking
up cpus from deep idle periods.

Right now deferrable timers are only available in the timer wheel and
therefor not available to user space applications. Though user space
applications want to optimize their timer usage for power consumption
as well, so exposing deferred timers via the existing timer APIs is
required.

There is no way to bring back timer wheel timers to user space
interfaces as they would reintroduce the problems of CLOCK_REALTIME
and clock setting again and add quite some mess to the various
interfaces.

So the proper solution is to extend the hrtimer functionality with
a deferrable mode.

The following series adds the functionality and makes it accessible
via the clock_nanosleep, timer_settime and timerfd_settime syscalls.

This series is RFC and largely untested.

Thanks,

	tglx

