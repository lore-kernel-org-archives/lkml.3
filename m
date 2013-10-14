Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3JNWnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:43:47 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57682 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab3JNWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:43:46 -0400
Date: Tue, 15 Oct 2013 00:43:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131014224333.GG13538@localhost.localdomain>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <20131014212830.GD5790@linux.vnet.ibm.com>
 <20131014215117.GE13538@localhost.localdomain>
 <525C70C6.60702@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <525C70C6.60702@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:31:34AM +0200, Knut Petersen wrote:
> On 14.10.2013 23:51, Frederic Weisbecker wrote:
> >Also knut, do you have a serial line?
> Yes, if really necesarry .... I´d prefer network

Hmm, you can try but it might not be working correcty after the fault.

> 
> >
> >If so may be looking at the timer events may help. Could you try to enable the following
> >timer events?
> >
> >       echo 1 > /sys/kernel/debug/tracing/events/timer/timer_cancel
> >       echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_entry
> >       echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_exit
> >       echo 1 > /sys/kernel/debug/tracing/events/timer/timer_init
> >       echo 1 > /sys/kernel/debug/tracing/events/timer/timer_start
> >
> >And also enable ftrace_dump_on_oops:
> >
> >       sysctl kernel.ftrace_dump_on_oops=1
> I assume you forgot .../enable several times ?!

Oops, sorry yep.

> 
> echo 1 > /sys/kernel/debug/tracing/events/timer/timer_cancel/enable
> echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_entry/enable
> echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_exit/enable
> echo 1 > /sys/kernel/debug/tracing/events/timer/timer_init/enable
> echo 1 > /sys/kernel/debug/tracing/events/timer/timer_start/enable
> sysctl kernel.ftrace_dump_on_oops=1
> 
> I added that to /etc/init.d/boot.local

Thanks! Now lets cross the fingers :)

> 
> 
> >
> >We may have some interesting clues about who manipulated the timer list last before
> >the oops happened.
> >
> >Thanks!
> >
> 
