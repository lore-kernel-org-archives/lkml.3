Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbaJ2K5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:57:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:41908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaJ2K5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:57:14 -0400
Date: Wed, 29 Oct 2014 11:57:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 9/9] rcu: Provide counterpart to
 rcu_dereference() for non-RCU situations
Message-ID: <20141029105704.GY3337@twins.programming.kicks-ass.net>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534202-27312-9-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414534202-27312-9-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:10:02PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Although rcu_dereference() and friends can be used in situations where
> object lifetimes are being managed by something other than RCU, the
> resulting sparse and lockdep-RCU noise can be annoying.  This commit
> therefore supplies a lockless_dereference(), which provides the
> protection for dereferences without the RCU-related debugging noise.
> 
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

> +#define lockless_dereference(p) \
> +({ \
> +	typeof(p) _________p1 = ACCESS_ONCE(p); \
> +	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
> +	(_________p1); \
> +})

Should we not have at least a single user along with this?
