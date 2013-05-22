Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3EVIbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:31:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3EVIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:31:13 -0400
Date: Wed, 22 May 2013 01:31:08 -0700 (PDT)
Message-Id: <20130522.013108.58504645261021804.davem@davemloft.net>
To: peterz@infradead.org
Cc: horms@verge.net.au, eric.dumazet@gmail.com, ja@ssi.bg, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, pablo@netfilter.org, dipankar@in.ibm.com
Subject: Re: [PATCH ipvs-next v3 0/2] sched: Add cond_resched_rcu_lock()
 helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130522075438.GO26912@twins.programming.kicks-ass.net>
References: <1369201832-17163-1-git-send-email-horms@verge.net.au>
	<20130522075438.GO26912@twins.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 22 May 2013 09:54:38 +0200

> On Wed, May 22, 2013 at 02:50:30PM +0900, Simon Horman wrote:
>> Add a helper that for use in loops which read data protected by RCU and
>> may have a large number of iterations.  Such an example is dumping the list
>> of connections known to IPVS: ip_vs_conn_array() and ip_vs_conn_seq_next().
>> 
>> This series also updates IPVS to use the helper.
>> 
>> Simon Horman (2):
>>   sched: add cond_resched_rcu() helper
>>   ipvs: use cond_resched_rcu() helper when walking connections
>> 
>>  include/linux/sched.h           |  9 +++++++++
>>  net/netfilter/ipvs/ip_vs_conn.c | 23 ++++++++---------------
>>  2 files changed, 17 insertions(+), 15 deletions(-)
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> 
> How do you want to go about merging this? Do you want to route it
> through the net tree or through -tip?

I think we can have Pablo merge it into his netfilter tree.
