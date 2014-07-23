Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaGWNPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:15:24 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:58096 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaGWNPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140723122849.GN11241@linux.vnet.ibm.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-16-git-send-email-bobby.prani@gmail.com> <20140723122849.GN11241@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 23 Jul 2014 09:14:51 -0400
Message-ID: <CAJhHMCDGGTtcW2ENQowKFoujLmqum8yn5ppH1RP=kv5UU+qdPw@mail.gmail.com>
Subject: Re: [PATCH 15/16] rcu: Check for a nocb cpu before trying to spawn
 nocb threads
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 8:28 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Jul 23, 2014 at 01:09:52AM -0400, Pranith Kumar wrote:
>> This commit tries to spawn nocb kthreads only when the CPU is marked as a nocb
>> cpu. This is a minor optimization.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>
> This only happens once at boot time, so I am happier with the single check
> at the bottom.  So sorry, but no.
>


Actually this happens whenever a CPU is coming online, but yes, it is
a minor optimization for hotplug.

>                                                         Thanx, Paul
>
>> ---
>>  kernel/rcu/tree_plugin.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
>> index 541c776..8abff0a 100644
>> --- a/kernel/rcu/tree_plugin.h
>> +++ b/kernel/rcu/tree_plugin.h
>> @@ -1490,7 +1490,8 @@ static void rcu_prepare_kthreads(int cpu)
>>               return;
>>
>>       rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
>> -     rcu_spawn_all_nocb_kthreads(cpu);
>> +     if (rcu_is_nocb_cpu(cpu))
>> +             rcu_spawn_all_nocb_kthreads(cpu);
>>  }
>>
>>  #else /* #ifdef CONFIG_RCU_BOOST */
>> --
>> 2.0.0.rc2
>>
>



-- 
Pranith
