Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbaH1FrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 01:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129AbaH1FrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 01:47:12 -0400
Date: Thu, 28 Aug 2014 11:16:49 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: Make nocb leader kthreads process pending callbacks
 after spawning
Message-ID: <20140828054649.GJ13052@grmbl.mre>
References: <1409172220-2804-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409172220-2804-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 27 Aug 2014 [16:43:40], Pranith Kumar wrote:
> The nocb callbacks generated before the nocb kthreads are spawned are
> enqueued in the nocb queue for later processing. Commit fbce7497ee5af ("rcu:
> Parallelize and economize NOCB kthread wakeups") introduced nocb leader kthreads
> which checked the nocb_leader_wake flag to see if there were any such pending
> callbacks. A case was reported in which newly spawned leader kthreads were not
> processing the pending callbacks as this flag was not set, which led to a boot
> hang.
> 
> The following commit ensures that the newly spawned nocb kthreads process the
> pending callbacks by allowing the kthreads to run immediately after spawning
> instead of waiting. This is done by inverting the logic of nocb_leader_wake
> tests to nocb_leader_sleep which allows us to use the default initialization of
> this flag to 0 to let the kthreads run.
> 
> Reported-by: Amit Shah <amit.shah@redhat.com>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Link: http://www.spinics.net/lists/kernel/msg1802899.html
> ---
>  kernel/rcu/tree.h        |  2 +-
>  kernel/rcu/tree_plugin.h | 24 ++++++++++++------------
>  2 files changed, 13 insertions(+), 13 deletions(-)

I'd have split this into two patches: one for the variable rename and
one for fixing the bug.

However, the backport Paul posted does work fine for me on master, so
you can add my

Tested-by: Amit Shah <amit.shah@redhat.com>

Thanks,

		Amit
