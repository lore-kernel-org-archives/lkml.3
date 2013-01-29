Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3A2F45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:56:57 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57326 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3A2F4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:56:55 -0500
Date: Mon, 28 Jan 2013 21:56:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Provide RCU CPU stall warnings for
 tiny RCU
Message-ID: <20130129055643.GS6395@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130127002328.GA4847@linux.vnet.ibm.com>
 <1359246227-5770-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130127105708.GD3119@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127105708.GD3119@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012905-5406-0000-0000-000004A90834
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 09:57:08PM +1100, Josh Triplett wrote:
> On Sat, Jan 26, 2013 at 04:23:46PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > Tiny RCU has historically omitted RCU CPU stall warnings in order to
> > reduce memory requirements, however, lack of these warnings caused
> > Thomas Gleixner some debugging pain recently.  Therefore, this commit
> > adds RCU CPU stall warnings to tiny RCU if RCU_TRACE=y.  This keeps
> > the memory footprint small, while still enabling CPU stall warnings
> > in kernels built to enable them.
> > 
> > Updated to include Josh Triplett's suggested use of RCU_STALL_COMMON
> > config variable to simplify #if expressions.
> > 
> > Reported-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> One suggestion below; with that change,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -486,6 +486,14 @@ config PREEMPT_RCU
> >  	  This option enables preemptible-RCU code that is common between
> >  	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
> >  
> > +config RCU_STALL_COMMON
> > +	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
> > +	help
> > +	  This option enables RCU CPU stall code that is common between
> > +	  the TINY and TREE variants of RCU.  The purpose is to allow
> > +	  the tiny variants to disable RCU CPU stall warnings, while
> > +	  making these warnings mandatory for the tree variants.
> > +
> [...]
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -970,7 +970,7 @@ config RCU_TORTURE_TEST_RUNNABLE
> >  
> >  config RCU_CPU_STALL_TIMEOUT
> >  	int "RCU CPU stall timeout in seconds"
> > -	depends on TREE_RCU || TREE_PREEMPT_RCU
> > +	depends on TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE
> 
> depends on RCU_STALL_COMMON

Good catch, fixed!

							Thanx, Paul

