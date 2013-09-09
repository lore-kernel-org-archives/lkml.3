Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3IIK4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:56:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47932 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3IIK4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:56:31 -0400
Date: Mon, 9 Sep 2013 12:56:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909105606.GL31370@twins.programming.kicks-ass.net>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <20130906113320.46b2ea3e@gandalf.local.home>
 <20130906164016.GB2706@somewhere>
 <20130906125238.3c5ef919@gandalf.local.home>
 <20130906170006.GC2706@somewhere>
 <20130906131631.6a0a192d@gandalf.local.home>
 <20130906175238.GV3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906175238.GV3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:52:38AM -0700, Paul E. McKenney wrote:
> How about if I made rcu_is_cpu_idle() be as follows?
> 
> int rcu_is_cpu_idle(void)
> {
> 	int ret;
> 
> 	ret = (atomic_read(&per_cpu(rcu_dynticks.dynticks,
> 				    raw_smp_processor_id())) & 0x1) == 0;
> 	return ret;
> }


No, please use __raw_get_cpu_var(), that generates far better code. Also
any such trickery needs a coherent comment.
