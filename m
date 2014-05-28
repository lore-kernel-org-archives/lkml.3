Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaE1AmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:42:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:14004 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753510AbaE1AmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:42:17 -0400
Message-ID: <1401237734.23277.1.camel@pippen.local.home>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with
 irqsoff tracers
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 27 May 2014 20:42:14 -0400
In-Reply-To: <53852999.7060907@codeaurora.org>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
	 <17051981.niWmA6MIgX@wuerfel> <20140527174847.7b405b5c@gandalf.local.home>
	 <53850FF3.8050107@codeaurora.org>
	 <20140527193050.4606a014@gandalf.local.home>
	 <53852999.7060907@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 17:11 -0700, Stephen Boyd wrote:

> cpuidle_enter_state() calls ktime_get() which on lockdep enabled builds
> calls seqcount_lockdep_reader_access() which calls local_irq_save() that

seqcount_lockdep_reader_access()?? Ug, I wonder if that should call
raw_local_irq_save/restore() as it's a lockdep helper to begin with. If
it's wrong then it's the lockdep infrastructure that broke, not the core
kernel.

Peter?

-- Steve


> then turns on the tracer again. Perhaps the problem is that irqsoff
> tracer is triggered even when we aren't transitioning between irqs on
> and irqs off? What about this patch? I assume there is a reason that
> this is wrong, but I don't know what it is.
> 


