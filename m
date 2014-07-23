Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaGWMtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:49:39 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:49941 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbaGWMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:49:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140723120654.GF11241@linux.vnet.ibm.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-3-git-send-email-bobby.prani@gmail.com> <20140723120654.GF11241@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 23 Jul 2014 08:49:06 -0400
Message-ID: <CAJhHMCC17qTfHUvmHw5OK8xfeqxvNeAXPhzT7+xgpny_dLnq0g@mail.gmail.com>
Subject: Re: [PATCH 02/16] rcu: Check return value for cpumask allocation
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

On Wed, Jul 23, 2014 at 8:06 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Jul 23, 2014 at 01:09:39AM -0400, Pranith Kumar wrote:
>> This commit add a check for return value of zalloc_cpumask_var() used while
>> allocating cpumask for rcu_nocb_mask.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> ---
>>  kernel/rcu/tree_plugin.h | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
>> index f07b643..bac9797 100644
>> --- a/kernel/rcu/tree_plugin.h
>> +++ b/kernel/rcu/tree_plugin.h
>> @@ -88,7 +88,10 @@ static void __init rcu_bootup_announce_oddness(void)
>>  #ifdef CONFIG_RCU_NOCB_CPU
>>  #ifndef CONFIG_RCU_NOCB_CPU_NONE
>>       if (!have_rcu_nocb_mask) {
>> -             zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
>> +             if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
>> +                     pr_info("rcu_nocb_mask allocation failed\n");
>> +                     return;
>
> Good catch, but this "return" is an accident waiting to happen.  The
> accident will happen as soon as another RCU option appears, and the
> person adding it quite naturally adds it at the end of this function.
> The cleanest approach is to make an rcu_bootup_announce_oddness_nocb()
> as one commit that does -only- code motion, and the make this change
> as another commit.
>

OK, I will resubmit this change as a 2 patch change.

-- 
Pranith
