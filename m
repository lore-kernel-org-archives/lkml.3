Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaFWRTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:19:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:58657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbaFWRTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:19:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,531,1400050800"; 
   d="scan'208";a="532793178"
Date: Mon, 23 Jun 2014 10:19:05 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, dave.hansen@intel.com,
        cl@gentwo.org, umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623171905.GG8178@tassilo.jf.intel.com>
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <20140623062615.GB19860@laptop.programming.kicks-ass.net>
 <20140623154931.GF8178@tassilo.jf.intel.com>
 <20140623164313.GA27233@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623164313.GA27233@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In 3.10, RCU had 14,046 lines of code, not counting documentation and
> test scripting.  In 3.15, RCU had 13,208 lines of code, again not counting
> documentation and test scripting.  That is a decrease of almost 1KLoC,
> so your wish is granted.

Ok that's good progress.

> CONFIG_RCU_NOCB_CPU, CONFIG_RCU_NOCB_CPU_NONE, CONFIG_RCU_NOCB_CPU_ZERO,
> and CONFIG_RCU_NOCB_CPU_ALL.  It also might be reasonable to replace
> uses of CONFIG_PROVE_RCU with CONFIG_PROVE_LOCKING, thus allowing
> CONFIG_PROVE_RCU to be eliminated.  CONFIG_PROVE_RCU_DELAY hasn't proven
> very good at finding bugs, so I am considering eliminating it as well.
> Given recent and planned changes related to RCU's stall-warning stack
> dumping, I hope to eliminate both CONFIG_RCU_CPU_STALL_VERBOSE and
> CONFIG_RCU_CPU_STALL_INFO, making them both happen unconditionally.
> (And yes, I should probably make CONFIG_RCU_CPU_STALL_INFO be the default
> for some time beforehand.)  I have also been considering getting rid of
> CONFIG_RCU_FANOUT_EXACT, given that it appears that no one uses it.

Yes please to all.

Sounds good thanks.

-Andi
