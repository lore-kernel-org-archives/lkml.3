Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3C0Qec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:34:32 -0400
Received: from 8bytes.org ([85.214.48.195]:47843 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3C0Qeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:34:31 -0400
Date: Wed, 27 Mar 2013 17:34:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130327163427.GN30540@8bytes.org>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
 <20130327131532.GL30540@8bytes.org>
 <1364393852.5053.74.camel@laptop>
 <20130327143715.GY4379@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327143715.GY4379@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 17:34:29 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51531f9523675553987564
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 07:37:15AM -0700, Paul E. McKenney wrote:
> On Wed, Mar 27, 2013 at 03:17:32PM +0100, Peter Zijlstra wrote:
> > On Wed, 2013-03-27 at 14:15 +0100, Joerg Roedel wrote:
> > > What makes me wonder here is that the code is preemptible in an
> > > rcu_read_locked section. As far as I know preemption needs to be
> > > disabled while holding the rcu_read_lock().
> > 
> > Nah, a long long time ago some -rt people complained to paulmck that
> > keeping preemption disabled over all this RCU stuff was killing
> > latencies. Paul liked the challenge and came up with some mind twisting
> > stuff to make it work.
> 
> What can I say?  I was young and foolish.  And I still am pretty
> foolish.  ;-)
> 
> But yes, you are not required to disable preemption across
> rcu_read_lock(), and rcu_read_lock() is not guaranteed to disable
> preemption.  So if you need preemption to be disabled, do it explicitly
> with preempt_disable(), local_irq_save(), rcu_read_lock_sched(),
> or whatever, because rcu_read_lock() isn't always going to disable
> preemption.
> 
> > If you're into that kind of pain, look at CONFIG_*_PREEMPT_RCU :-)
> 
> Or just set CONFIG_PREEMPT=y, which will set CONFIG_TREE_PREEMPT_RCU=y
> on CONFIG_SMP=y builds and will set CONFIG_TINY_PREEMPT_RCU=y otherwise.
> (But please note that CONFIG_TINY_PREEMPT_RCU is going away, after which
> CONFIG_PREEMPT=y will always set CONFIG_TREE_PREEMPT_RCU=y.)
> 
> 							Thanx, Paul
> 
> > But yeah, you need to have that stuff enabled before you can hit this
> > particular snag.

Interesting read, thanks guys. I think I should have a look into the
tree-preempt implementation and try to understand it :)


	Joerg


