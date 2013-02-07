Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab3BGRly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:41:54 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59855 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab3BGRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:41:53 -0500
Date: Thu, 7 Feb 2013 09:37:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
Message-ID: <20130207173756.GW2632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
 <1360205415.2621.60.camel@gandalf.local.home>
 <20130207111025.GD8945@gmail.com>
 <1360253520.2621.66.camel@gandalf.local.home>
 <20130207163004.GS2632@linux.vnet.ibm.com>
 <1360256781.2621.80.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360256781.2621.80.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020717-7408-0000-0000-00000C9B6A5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 12:06:21PM -0500, Steven Rostedt wrote:
> On Thu, 2013-02-07 at 08:30 -0800, Paul E. McKenney wrote:
> 
> > I suspect that removal of jiffies from the kernel will take a few stages,
> > with RCU being one of the laggards for awhile.  Making RCU's state
> > machine depend wholly on process-based execution will take some care
> > and experimentation, especially for extreme and corner-case workloads.
> > For example, having RCU OOM the system just because a specific CPU was
> > unable to run some RCU kthread for an extended time is something to
> > be avoided.  ;-)
> 
> Tickless doesn't mean no timeouts or periodic timers. I think we will
> always have some sort of dynamic tick when needed. It will just be more
> event driven then something that goes off constantly.

As long as we don't end up replacing a single tick with multiple hrtimers
(or whatever), ending up with more overhead and disruption than we
started with.  ;-)

							Thanx, Paul

