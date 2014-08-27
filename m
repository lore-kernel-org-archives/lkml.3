Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaH0BKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:10:43 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:63041 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbaH0BKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140723144509.GW11241@linux.vnet.ibm.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com> <20140723144509.GW11241@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 26 Aug 2014 21:10:10 -0400
Message-ID: <CAJhHMCCsiosr627bh+fTYVtGhgNXvGZUbmFQqn-dS5L5N9_81Q@mail.gmail.com>
Subject: Re: [PATCH 00/16] rcu: Some minor fixes and cleanups
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:45 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Jul 23, 2014 at 01:09:37AM -0400, Pranith Kumar wrote:
>> Hi Paul,
>>
>> This is a series of minor fixes and cleanup patches which I found while studying
>> the code. All my previous pending (but not rejected ;) patches are superseded by
>> this series, expect the rcutorture snprintf changes. I am still waiting for you
>> to decide on that one :)
>>
>> These changes have been tested by the kvm rcutorture test setup. Some tests give
>> me stall warnings, but otherwise have SUCCESS messages in the logs.
>
> For patches 1, 3, 5, 8, 12, and 13, once you get a Reviewed-by from one
> of the co-maintainers or designated reviewers, I will queue them.
> The other patches I have responded to.
>

Hi Paul, just a reminder so that these don't get forgotten :)

>>
>> Pranith Kumar (16):
>>   rcu: Use rcu_num_nodes instead of NUM_RCU_NODES
>>   rcu: Check return value for cpumask allocation
>>   rcu: Fix comment for gp_state field values
>>   rcu: Remove redundant check for an online CPU
>>   rcu: Add noreturn attribute to boost kthread
>>   rcu: Clear gp_flags only when actually starting new gp
>>   rcu: Save and restore irq flags in rcu_gp_cleanup()
>>   rcu: Clean up rcu_spawn_one_boost_kthread()
>>   rcu: Remove redundant check for online cpu
>>   rcu: Check for RCU_FLAG_GP_INIT bit in gp_flags for spurious wakeup
>>   rcu: Check for spurious wakeup using return value
>>   rcu: Rename rcu_spawn_gp_kthread() to rcu_spawn_kthreads()
>>   rcu: Spawn nocb kthreads from rcu_prepare_kthreads()
>>   rcu: Remove redundant checks for rcu_scheduler_fully_active
>>   rcu: Check for a nocb cpu before trying to spawn nocb threads
>>   rcu: kvm.sh: Fix error when you pass --cpus argument
>>
>>  kernel/rcu/tree.c                             | 42 ++++++++++++++-------------
>>  kernel/rcu/tree.h                             |  4 +--
>>  kernel/rcu/tree_plugin.h                      | 40 +++++++++++++------------
>>  tools/testing/selftests/rcutorture/bin/kvm.sh |  4 +--
>>  4 files changed, 47 insertions(+), 43 deletions(-)
>>
>> --
>> 2.0.0.rc2
>>
>



-- 
Pranith
