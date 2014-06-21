Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbaFUBTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 21:19:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16686 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753545AbaFUBTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 21:19:33 -0400
Date: Fri, 20 Jun 2014 21:19:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [for-next][PATCH v2 1/3] tracing: Fix syscall_*regfunc() vs
 copy_process() race
Message-ID: <20140620211930.29bd1d66@gandalf.local.home>
In-Reply-To: <20140621011125.GA23415@linux.vnet.ibm.com>
References: <20140620104518.722157733@goodmis.org>
	<20140620104711.140660296@goodmis.org>
	<20140621011125.GA23415@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 18:11:25 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Jun 20, 2014 at 06:45:19AM -0400, Steven Rostedt wrote:
> > From: Oleg Nesterov <oleg@redhat.com>
> > 
> > syscall_regfunc() and syscall_unregfunc() should set/clear
> > TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> > with copy_process() and miss the new child which was not added to
> > the process/thread lists yet.
> > 
> > Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> > under tasklist.
> > 
> > Link: http://lkml.kernel.org/p/20140413185854.GB20668@redhat.com
> > 
> > Cc: stable@vger.kernel.org # 2.6.33
> > Fixes: a871bd33a6c0 "tracing: Add syscall tracepoints"
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

I don't usually rebase my for-next branch for acks, but I already
rebased once for fixing an issue, and it's early in the rc cycle, and
this is the first patch on the branch, so I think I will do it.

Thanks!

-- Steve
