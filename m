Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaE1OJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:09:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:51750 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753667AbaE1OJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:09:13 -0400
Date: Wed, 28 May 2014 10:09:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, rjw@rjwysocki.net
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with
 irqsoff tracers
Message-ID: <20140528100910.6035ea7d@gandalf.local.home>
In-Reply-To: <20140528072852.GN11096@twins.programming.kicks-ass.net>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
	<17051981.niWmA6MIgX@wuerfel>
	<20140527174847.7b405b5c@gandalf.local.home>
	<53850FF3.8050107@codeaurora.org>
	<20140527193050.4606a014@gandalf.local.home>
	<20140528072852.GN11096@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 09:28:52 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, May 27, 2014 at 07:30:50PM -0400, Steven Rostedt wrote:
> > Paul, Peter, see anything wrong with this?
> 
> You mean, aside from that it won't actually apply due to that code
> having been massively overhauled?
> 
> I suppose the same thing Arnd mentioned, the cpuidle_enter() thing can
> be huge, but is we're going to have to push this down into all cpuidle
> drivers we're not going to be happy.
> 

I believe that the stop/start_critical_timings() can nest. If not, I
can make them do so. Thus, we could start adding them in the depths of
the cpuidle drivers. If we miss one, we may not notice until someone
reports a large latency due to it.  And that is only if the driver
itself calls local_irq_save/restore().

-- Steve
