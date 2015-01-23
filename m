Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbbAWVwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:52:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32070 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbAWVwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:52:36 -0500
Message-ID: <54C2C278.1000608@oracle.com>
Date: Fri, 23 Jan 2015 16:51:52 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at kernel/rcu/tree_plugin.h:337
 rcu_read_unlock_special+0x369/0x550()
References: <20150118232255.GD9719@linux.vnet.ibm.com> <54BE76B9.7070907@oracle.com> <20150121025754.GV9719@linux.vnet.ibm.com> <54BFC979.8040107@oracle.com> <20150122004305.GJ9719@linux.vnet.ibm.com> <54C1BFFD.9060707@oracle.com> <20150123035158.GP9719@linux.vnet.ibm.com> <54C1C7D2.906@oracle.com> <54C1C899.8000106@oracle.com> <20150123065542.GQ9719@linux.vnet.ibm.com> <20150123093644.GA11175@linux.vnet.ibm.com>
In-Reply-To: <20150123093644.GA11175@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 04:36 AM, Paul E. McKenney wrote:
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 8669de884445..ec99dc16aa38 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -322,6 +322,7 @@ void rcu_read_unlock_special(struct task_struct *t)
>  	special = t->rcu_read_unlock_special;
>  	if (special.b.need_qs) {
>  		rcu_preempt_qs();
> +		t->rcu_read_unlock_special.need_qs = false;

It didn't compile, I've used:

		t->rcu_read_unlock_special.b.need_qs = false;


Thanks,
Sasha
