Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaHBO66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 10:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaHBO65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 10:58:57 -0400
Date: Sat, 2 Aug 2014 16:56:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140802145616.GA18195@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Paul E. McKenney wrote:
>
> +		rcu_read_lock();
> +		for_each_process_thread(g, t) {
> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> +			    !is_idle_task(t)) {

I didn't notice this check before, but it is not needed. for_each_process()
can see the idle threads, there are not on process/thread lists.

But this doesn't really matter, the main problem is that I still think that
for_each_process_thread() can't really work anyway.

Oleg.

