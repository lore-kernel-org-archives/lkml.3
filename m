Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaHHQtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:49:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:10450 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757315AbaHHQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:49:34 -0400
Date: Fri, 8 Aug 2014 12:49:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808124931.07c3b78a@gandalf.local.home>
In-Reply-To: <20140808163905.GA5821@linux.vnet.ibm.com>
References: <20140807184635.GI3588@twins.programming.kicks-ass.net>
	<20140807154907.6f59cf6e@gandalf.local.home>
	<20140807155326.18481e66@gandalf.local.home>
	<20140807200813.GB3935@laptop>
	<20140807171823.1a481290@gandalf.local.home>
	<20140808064020.GZ9918@twins.programming.kicks-ass.net>
	<20140808101221.21056900@gandalf.local.home>
	<20140808143413.GB9918@twins.programming.kicks-ass.net>
	<20140808105858.171da847@gandalf.local.home>
	<20140808162714.GG9918@twins.programming.kicks-ass.net>
	<20140808163905.GA5821@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 09:39:05 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> Unless this is done in idle, at which point RCU-sched is studiously
> ignoring any preempt_disable() sections.

ftrace doesn't use synchronize_sched() today because of this. It
instead just does a "schedule_on_each_cpu()" and waits for that to
return before going further.

-- Steve
