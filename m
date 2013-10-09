Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3JIW1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:27:07 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50543 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3JIW1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:27:05 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 9 Oct 2013 15:26:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v2 tip/core/rcu 01/13] rcu: Make rcu_assign_pointer's
 assignment volatile and type-safe
Message-ID: <20131009222656.GC11709@jtriplet-mobl1>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 02:29:34PM -0700, Paul E. McKenney wrote:
> From: Josh Triplett <josh@joshtriplett.org>
> 
> rcu_assign_pointer needs to use ACCESS_ONCE to make the assignment to
> the destination pointer volatile, to protect against compilers too
> clever for their own good.
> 
> In addition, since rcu_assign_pointer force-casts the source pointer to
> add the __rcu address space (overriding any existing address space), add
> an explicit check that the source pointer has the __kernel address space
> to start with.
> 
> This new check produces warnings like this, when attempting to assign
> from a __user pointer:
> 
> test.c:25:9: warning: incorrect type in argument 2 (different address spaces)
> test.c:25:9:    expected struct foo *<noident>
> test.c:25:9:    got struct foo [noderef] <asn:1>*badsrc
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

See my responses to the cover letter; I'd suggest making this the last
patch of the series to avoid introducing and subsequently fixing
warnings.

I'd suggest adding the comment I mentioned in my second response as the
new first patch of the series, since it applies to the old version as
well; thus, the series would first add the comment documenting the
evaluate-once constraint, then add all the calls to rcu_access_pointer,
and finally add this patch introducing the sparse checking.

- Josh Triplett
