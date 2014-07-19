Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaGSGcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 02:32:36 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:54987 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaGSGcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 02:32:35 -0400
Message-ID: <53CA10FF.4050106@gmail.com>
Date: Sat, 19 Jul 2014 02:32:31 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcu: Check for have_rcu_nocb_mask instead of rcu_nocb_mask
References: <1405632611-29872-1-git-send-email-bobby.prani@gmail.com> <20140717234920.GD8690@linux.vnet.ibm.com> <53C86615.3040107@gmail.com> <20140719061021.GK8690@linux.vnet.ibm.com>
In-Reply-To: <20140719061021.GK8690@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2014 02:10 AM, Paul E. McKenney wrote:

>> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
>> index ce8c331..8f987c1 100644
>> --- a/kernel/rcu/tree_plugin.h
>> +++ b/kernel/rcu/tree_plugin.h
>> @@ -2053,9 +2053,10 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
>>  /* Is the specified CPU a no-CBs CPU? */
>>  bool rcu_is_nocb_cpu(int cpu)
>>  {
>> -	if (have_rcu_nocb_mask)
>> -		return cpumask_test_cpu(cpu, rcu_nocb_mask);
>> -	return false;
>> +	if (!have_rcu_nocb_mask)
>> +		return false;
>> +
>> +	return cpumask_test_cpu(cpu, rcu_nocb_mask);
> 
> Hmmm...  That was a subtle way to tell me that my feedback was bogus.  ;-)
> I guess I need to stop reviewing patches at 2AM local time.
> 
> Anyway, you are correct, this was OK to start with, so I am dropping
> this hunk.
> 

I thought you wanted me to change the check of the have_rcu_nocb_mask, and I
really think the new version is better. But yes, more of a style change :)

--
Pranith

