Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaGQCUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:20:11 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:54764 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaGQCUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:20:08 -0400
Message-ID: <53C732F1.7030005@gmail.com>
Date: Wed, 16 Jul 2014 22:20:33 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com> <1405463509-2468-2-git-send-email-bobby.prani@gmail.com> <20140715225313.GB24290@cloud> <53C5B1F7.3000409@gmail.com> <20140716124729.GR8690@linux.vnet.ibm.com> <53C67E2E.7080402@gmail.com> <53C71EF3.8010901@cn.fujitsu.com> <53C72080.5040501@gmail.com> <20140717021405.GA1102@thin>
In-Reply-To: <20140717021405.GA1102@thin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 10:14 PM, Josh Triplett wrote:
> On Wed, Jul 16, 2014 at 09:01:52PM -0400, Pranith Kumar wrote:
>> Sure, please find an updated patch with Josh Triplett's sign-off added:
> 
> It appears to have a reviewed-by from someone named "Joe Tripplett"
> instead. ;)
> 

I apologize for fat-fingering this.
Since I've sent one too many emails in this thread already, I suppose on more can not do much harm :)

This time with Reviewed-by Lai Jiangshan added and Reviewed-by Josh Triplett corrected.

From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 14 Jul 2014 16:01:05 -0400
Subject: [PATCH 2/3] rcu: Remove stale comment in tree.c

This commit removes a stale comment in rcu/tree.c which was left out when some
code was moved around previously in the commit

2036d94a7b61 ("rcu:  Rework detection of use of RCU by offline CPUs")

For reference, the following updated comment exists a few lines below this which
means the same.

/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcu/tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a1abaa8..e67246e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2211,8 +2211,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/* Adjust any no-longer-needed kthreads. */
 	rcu_boost_kthread_setaffinity(rnp, -1);
 
-	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
-
 	/* Exclude any attempts to start a new grace period. */
 	mutex_lock(&rsp->onoff_mutex);
 	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
-- 
1.9.1


