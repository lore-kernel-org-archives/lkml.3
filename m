Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaHDB1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 21:27:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2053 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbaHDB13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 21:27:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,258,1406563200"; 
   d="scan'208";a="34122938"
Message-ID: <53DEE1CD.4000705@cn.fujitsu.com>
Date: Mon, 4 Aug 2014 09:28:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <dipankar@in.ibm.com>,
        <akpm@linux-foundation.org>, <mathieu.desnoyers@efficios.com>,
        <josh@joshtriplett.org>, <tglx@linutronix.de>, <rostedt@goodmis.org>,
        <dhowells@redhat.com>, <edumazet@google.com>, <dvhart@linux.intel.com>,
        <fweisbec@gmail.com>, <oleg@redhat.com>, <bobby.prani@gmail.com>
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 05:55 AM, Paul E. McKenney wrote:
> +		rcu_read_lock();
> +		for_each_process_thread(g, t) {
> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> +			    !is_idle_task(t)) {
> +				get_task_struct(t);
> +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> +				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> +				list_add(&t->rcu_tasks_holdout_list,
> +					 &rcu_tasks_holdouts);

This loop will collect all the runnable tasks.  It is too much tasks.
Is it possible to collect only on_cpu tasks or PREEMPT_ACTIVE tasks?
It seems hard to achieve it.
