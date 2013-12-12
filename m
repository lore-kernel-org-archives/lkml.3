Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3LLEKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 23:10:54 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60372 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3LLEKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 23:10:52 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 11 Dec 2013 20:10:37 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH v2 tip/core/rcu 0/4] Documentation changes for 3.14
Message-ID: <20131212041037.GA21050@leaf>
References: <20131211230823.GA12448@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211230823.GA12448@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 03:08:23PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> This series once again attempts to improve rcu_assign_pointer()'s
> relationship with sparse.
> 
> 1.	Add a comment indicating that despite appearances,
> 	rcu_assign_pointer() really only evaluates its arguments once,
> 	as a cpp macro should.
> 
> 2.	Replace rcu_assign_pointer() of NULL with RCU_INIT_POINTER() to
> 	silence a sparse warning.
> 
> 3.	Apply ACCESS_ONCE() to rcu_assign_pointer()'s target to prevent
> 	comiler mischief.  Also require that the source pointer be from
> 	the kernel address space.  Sometimes it can be from the RCU address
> 	space, which necessitates the remaining patches in this series.
> 	Which, it must be admitted, apply to a very small fraction of
> 	the rcu_assign_pointer() invocations in the kernel.  This commit
> 	courtesy of Josh Triplett.
> 
> 4.	Add an RCU_INITIALIZER() for compile-time initialization of
> 	global RCU-protected pointers.

For all the patches (other than the one I wrote, for obvious reasons):
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
