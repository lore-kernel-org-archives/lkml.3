Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbaGPN26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:28:58 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:55818 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaGPN2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:28:53 -0400
Message-ID: <53C67E2E.7080402@gmail.com>
Date: Wed, 16 Jul 2014 09:29:18 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@joshtriplett.org, Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com> <1405463509-2468-2-git-send-email-bobby.prani@gmail.com> <20140715225313.GB24290@cloud> <53C5B1F7.3000409@gmail.com> <20140716124729.GR8690@linux.vnet.ibm.com>
In-Reply-To: <20140716124729.GR8690@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 08:47 AM, Paul E. McKenney wrote:
> On Tue, Jul 15, 2014 at 06:57:59PM -0400, Pranith Kumar wrote:
>>
>> On 07/15/2014 06:53 PM, josh@joshtriplett.org wrote:
>>> On Tue, Jul 15, 2014 at 06:31:48PM -0400, Pranith Kumar wrote:
>>>> This commit removes a stale comment in rcu/tree.c.
>>>> FYI, an updated comment exists a few lines below this.
>>>>
>>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>> In general, when removing a stale comment, I'd suggest explaining why
>>> the comment is stale.  Was code removed without removing the
>>> corresponding comment, or was code changed such that the comment no
>>> longer applies, or...?
>>
>> I guess it was left out when code was moved around previously. And I did mention that an updated comment is there a few lines below.
>>
>> For reference this is the new comment which is below the old comment, they mean the same :)
>>
>>     /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
> 
> Indeed that is the case.
> 
> Please update the commit log with this explanation and resend.
> 
> 								Thanx, Paul
> 

Please find the updated patch below.

--
Pranith

From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 14 Jul 2014 16:01:05 -0400
Subject: [PATCH 2/3] rcu: Remove stale comment in tree.c

This commit removes a stale comment in rcu/tree.c which was left out when some
code was moved around previously.

For reference, the following updated comment exists a few lines below this which
means the same.

/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
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

