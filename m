Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbaEMN3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:29:21 -0400
Received: from ns.horizon.com ([71.41.210.147]:28205 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759900AbaEMN3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:29:20 -0400
Date: 13 May 2014 09:29:18 -0400
Message-ID: <20140513132918.29216.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mathieu.desnoyers@efficios.com
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping seqlock
Cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <2004310918.15554.1399982845138.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We could expose a new clock type (besides monotonic and realtime) that is
> documented as non-strictly monotonic. It may return a time very slightly in
> the past if readers race with clock source frequency change. The caller could
> handle this situation (e.g. in user-space) by keeping its own per-cpu or
> per-thread "last clock value" data structure (something we cannot do in a
> vDSO) if it really cares about per-cpu/thread clock monotonicity.

That the first of two options I proposed.  The problem, with respect to
the immediate problem of debugging during a write deadlocking, is
that it makes a more complex API which callers must understand the
subtleties of.

Perhaps necessary, but definitely a minus.

> This could be implemented with the scheme I proposed as a prototype here:
> 
>    https://lkml.org/lkml/2013/9/14/136

I'm working my way though it.  I definitely like the first patch!

> Thoughts ?

I was trying to tackle the "hard problem" of making *all* time reads
non-blocking, with monotonicity guarantees.  There has to be *some* bound
on blocking times (in particular, time between reading hardware tiemrs
and translating them to real time), but they can be reasonably long.

I think I have an idea that could work, but given the hairiness of
the timeeeping code, implementing it would be a major project.
