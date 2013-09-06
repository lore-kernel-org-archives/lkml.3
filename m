Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3IFRVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:21:32 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50063 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IFRVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:21:31 -0400
Message-ID: <1378488088.31445.39.camel@edumazet-glaptop>
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, sbw@mit.edu
Date: Fri, 06 Sep 2013 10:21:28 -0700
In-Reply-To: <20130906151851.GQ3966@linux.vnet.ibm.com>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	 <20130906105934.GF20519@somewhere>
	 <20130906151851.GQ3966@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-06 at 08:18 -0700, Paul E. McKenney wrote:

> int rcu_is_cpu_idle(void)
> {
> 	int ret;
> 
> 	preempt_disable();
> 	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> 	preempt_enable();
> 	return ret;
> }

Paul I find this very confusing.

If caller doesn't have preemption disabled, what could be the meaning of
this rcu_is_cpu_idle() call ?

Its result is meaningless if suddenly thread is preempted, so what is
the point ?

Sorry if this is obvious to you.


