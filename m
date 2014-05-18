Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaERP6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:58:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49633 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaERP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:58:42 -0400
Date: Sun, 18 May 2014 08:58:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
Message-ID: <20140518155815.GK4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
 <20140514154459.GE4570@linux.vnet.ibm.com>
 <1400123931.5175.38.camel@marge.simpson.net>
 <1400386954.5140.36.camel@marge.simpson.net>
 <20140518052039.GF4570@linux.vnet.ibm.com>
 <1400402201.5166.13.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400402201.5166.13.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051815-3532-0000-0000-000001D525DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 10:36:41AM +0200, Mike Galbraith wrote:
> On Sat, 2014-05-17 at 22:20 -0700, Paul E. McKenney wrote:
> 
> > If you are saying that turning on nohz_full doesn't help unless you
> > also ensure that there is only one runnable task per CPU, I completely
> > agree.  If you are saying something else, you lost me.  ;-)
> 
> Yup, that's it more or less.  It's not only single task loads that could
> benefit from better isolation, but if isolation improving measures are
> tied to nohz_full, other sensitive loads will suffer if they try to use
> isolation improvements.

So you are arguing for a separate Kconfig variable that does the isolation?
So that NO_HZ_FULL selects this new variable, and (for example) RCU
uses this new variable to decide when to pin the grace-period kthreads
onto the housekeeping CPU?

							Thanx, Paul

