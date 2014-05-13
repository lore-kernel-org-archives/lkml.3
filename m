Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbaEMNja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:39:30 -0400
Received: from mail.efficios.com ([78.47.125.74]:40268 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbaEMNj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:39:26 -0400
Date: Tue, 13 May 2014 13:39:24 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: George Spelvin <linux@horizon.com>
Cc: john stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Message-ID: <822806193.15621.1399988364196.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140513132918.29216.qmail@ns.horizon.com>
References: <20140513132918.29216.qmail@ns.horizon.com>
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding
 timekeeping seqlock
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: timekeeping: Use printk_deferred when holding timekeeping seqlock
Thread-Index: FbmnX1XcBdJ5t30nAwLPawzLQyNRdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "George Spelvin" <linux@horizon.com>
> To: linux@horizon.com, "mathieu desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "john stultz" <john.stultz@linaro.org>, linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
> Sent: Tuesday, May 13, 2014 9:29:18 AM
> Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping seqlock
> 
> > We could expose a new clock type (besides monotonic and realtime) that is
> > documented as non-strictly monotonic. It may return a time very slightly in
> > the past if readers race with clock source frequency change. The caller
> > could
> > handle this situation (e.g. in user-space) by keeping its own per-cpu or
> > per-thread "last clock value" data structure (something we cannot do in a
> > vDSO) if it really cares about per-cpu/thread clock monotonicity.
> 
> That the first of two options I proposed.  The problem, with respect to
> the immediate problem of debugging during a write deadlocking, is
> that it makes a more complex API which callers must understand the
> subtleties of.
> 
> Perhaps necessary, but definitely a minus.
> 
> > This could be implemented with the scheme I proposed as a prototype here:
> > 
> >    https://lkml.org/lkml/2013/9/14/136
> 
> I'm working my way though it.  I definitely like the first patch!

Thanks! :)

> 
> > Thoughts ?
> 
> I was trying to tackle the "hard problem" of making *all* time reads
> non-blocking, with monotonicity guarantees.  There has to be *some* bound
> on blocking times (in particular, time between reading hardware tiemrs
> and translating them to real time), but they can be reasonably long.

What I gathered from my past discussion with John on this topic is that
virtualization blows away pretty much any assumption we can make on
"update should be reasonably short". A virtualized CPU can be preempted
for a rather long time (AFAIU not possible to bound).

> I think I have an idea that could work, but given the hairiness of
> the timeeeping code, implementing it would be a major project.

Indeed, timekeeping is not for the faint of heart. ;-)

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
