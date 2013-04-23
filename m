Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3DWVCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:02:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53892 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3DWVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:02:47 -0400
Date: Tue, 23 Apr 2013 14:01:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] nohz: Add basic tracing
Message-ID: <20130423210156.GD3427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1366664905-21884-1-git-send-email-fweisbec@gmail.com>
 <1366664905-21884-3-git-send-email-fweisbec@gmail.com>
 <0000013e38188092-7e0b72ea-9ae0-417c-902a-5e8a88282073-000000@email.amazonses.com>
 <1366747223.9609.163.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366747223.9609.163.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042321-2876-0000-0000-000007D6D94A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 04:00:23PM -0400, Steven Rostedt wrote:
> On Tue, 2013-04-23 at 18:12 +0000, Christoph Lameter wrote:
> > On Mon, 22 Apr 2013, Frederic Weisbecker wrote:
> > 
> > > It's not obvious to find out why the full dynticks subsystem
> > > doesn't always stop the tick: whether this is due to kthreads,
> > > posix timers, perf events, etc...
> > >
> > > These new tracepoints are here to help the user diagnose
> > > the failures and test this feature.
> > 
> > Very good. This will help a lot.
> 
> You can also do:
> 
> cd /sys/kernel/debug/tracing
> echo 1 > max_graph_depth
> echo function_graph > current_tracer
> 
> And then run your code, and look to see what happens on the cpu in
> question:
> 
> cat per_cpu/cpuX/trace
> 
> The "max_graph_depth" of one will make the function graph tracer just
> trace the first function that enters the kernel. You'll be able to see
> if the kernel did anything to your userspace application that wasn't
> planned.
> 
> "max_graph_depth" was added in 3.9-rc1

Very cool!  I have added this to the documentation.

							Thanx, Paul

