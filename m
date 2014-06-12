Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaFLAWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:22:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:36176 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaFLAWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:22:43 -0400
Date: Thu, 12 Jun 2014 02:22:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        linux-security-module@vger.kernel.org
Subject: Re: [patch 13/13] tomoyo: Use sensible time interface
In-Reply-To: <CALAqxLUtmY3JeHeq_RXz-Sc_jjyJQv=VRUr6bXtAge1+6bEXDA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406120216480.5170@nanos>
References: <20140611234024.103571777@linutronix.de> <20140611234607.775273584@linutronix.de> <CALAqxLUtmY3JeHeq_RXz-Sc_jjyJQv=VRUr6bXtAge1+6bEXDA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, John Stultz wrote:

> On Wed, Jun 11, 2014 at 4:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > There is no point in calling gettimeofday if only the seconds part of
> > the timespec is used. Use get_seconds() instead. It's not only the
> > proper interface it's also faster.
> 
> My only caution here is you only get tick-granular time here. So if
> the second rolled over after the last tick, you'd get the previous
> second when you call get_seconds(). This can cause some surprising
> effects if the get_seconds() return value is mixed with clocksource
> granular gettimeofday() calls.

If the whole thing only cares about the seconds value, then where is
the problem?

Even if you call gettimeofday() then you still can observe this

gettimeofday(ts)
	ts.tv_sec = 99
	ts.tv_nsec = 999999999

So if you readout the related value ONE nanosecond later, then this
value will have
	ts.tv_sec = 100
	ts.tv_nsec = 0

So what's the point? The tomoyo code chose to take seconds granular
time stamps for whatever reasons. So it should be able to deal with
that, right?

Thanks,

	tglx


