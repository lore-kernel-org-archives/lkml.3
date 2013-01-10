Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3AJUTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:19:32 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:40068 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab3AJUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:19:31 -0500
Date: Thu, 10 Jan 2013 12:18:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 1/1] Tiny RCU changes for 3.9
Message-ID: <20130110201832.GV2491@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130105175059.GA15961@linux.vnet.ibm.com>
 <20130107155810.GC11145@leaf>
 <20130107165748.GF2525@linux.vnet.ibm.com>
 <20130107175606.GA9962@jtriplet-mobl1>
 <20130107221915.GA2525@linux.vnet.ibm.com>
 <20130108042249.GB12974@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108042249.GB12974@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011020-3620-0000-0000-000000DD34BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 08:22:50PM -0800, Josh Triplett wrote:
> On Mon, Jan 07, 2013 at 02:19:15PM -0800, Paul E. McKenney wrote:
> > On Mon, Jan 07, 2013 at 09:56:06AM -0800, Josh Triplett wrote:
> > > On Mon, Jan 07, 2013 at 08:57:48AM -0800, Paul E. McKenney wrote:
> > > > On Mon, Jan 07, 2013 at 07:58:10AM -0800, Josh Triplett wrote:
> > > > > This patch seems reasonable to me, but the repeated use of #if
> > > > > defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE) seems somewhat
> > > > > annoying, and fragile if you ever decide to change the conditions.  How
> > > > > about defining an appropriate symbol in Kconfig for stall warnings, and
> > > > > using that?
> > > > 
> > > > But I only just removed the config option for SMP RCU stall warnings.  ;-)
> > > > 
> > > > But I must agree that "defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE)"
> > > > is a bit obscure.  The rationale is that RCU stall warnings are
> > > > unconditionally enabled in SMP kernels, but don't want to be in
> > > > TINY_RCU kernels due to size constraints.  I therefore put it under
> > > > CONFIG_RCU_TRACE, which also contains other TINY_RCU debugging-style
> > > > options.  Would adding a comment to this effect help?
> > > 
> > > I understand the rationale; I just think it would become clearer if you
> > > added an internal-only Kconfig symbol selected in both cases and change
> > > the conditionals to use that.
> > 
> > My concern was that this would confuse people into thinking that the
> > code under those #ifdefs was all the stall-warning code that there was.
> > 
> > I suppose this could be forestalled with a suitably clever name...
> > CONFIG_RCU_CPU_STALL_TINY_TOO?  Better names?
> 
> How about CONFIG_RCU_STALL_COMMON, with associated help text saying
> "include the stall-detection code common to both rcutree and rcutiny"?

Sold!!!  Especially given that I am creating the commit to allow
TREE_PREEMPT_RCU to be used on UP systems with an eye towards getting
rid of TINY_PREEMPT_RCU.  ;-)

							Thanx, Paul

