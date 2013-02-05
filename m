Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3BEBh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:37:57 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:38789 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3BEBhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:37:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130204172001.8bb358b0.akpm@linux-foundation.org>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
	<20130204172001.8bb358b0.akpm@linux-foundation.org>
Date: Tue, 5 Feb 2013 02:37:54 +0100
Message-ID: <CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/5 Andrew Morton <akpm@linux-foundation.org>:
> On Tue,  5 Feb 2013 01:51:18 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>>       printk: Wake up klogd using irq_work
>
> That seems reasonable.
>
> I'm wondering if we can now remove the printk_sched() special-case.
> iirc, that was needed because wake_up(klogd) would deadlock when called
> from sched internals.  But now that wakeup is punted to the timer tick,
> perhaps this is now unnecessary?

I fear irq work doesn't change much the picture in this regard. Before
irq work, printk() and printk_sched() were already relying on the tick
(printk_tick()) to do the wake up on klogd clients. I guess that the
deadlocks referenced by Peter were about printk() internals. May be
logbuf_lock against some other scheduler lock?

>
> (Maybe there were other problems, but the 3ccf3e8306 is poor, and its
> author is unavailable.  There's a lesson there!)
