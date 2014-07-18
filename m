Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbaGRNMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:12:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44510 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761848AbaGRNMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:42 -0400
Message-ID: <53C91CA9.7060103@oracle.com>
Date: Fri, 18 Jul 2014 09:10:01 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Create rcuo kthreads only for
 onlined CPUs
References: <20140714100604.GA9905@linux.vnet.ibm.com> <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com> <1405332404-10094-2-git-send-email-paulmck@linux.vnet.ibm.com> <53C9023D.3090007@oracle.com> <20140718125516.GH8690@linux.vnet.ibm.com>
In-Reply-To: <20140718125516.GH8690@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 08:55 AM, Paul E. McKenney wrote:
> On Fri, Jul 18, 2014 at 07:17:17AM -0400, Sasha Levin wrote:
>> > On 07/14/2014 06:06 AM, Paul E. McKenney wrote:
>>> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>>> > > 
>>> > > RCU currently uses for_each_possible_cpu() to spawn rcuo kthreads,
>>> > > which can result in more rcuo kthreads than one would expect, for
>>> > > example, derRichard reported 64 CPUs worth of rcuo kthreads on an
>>> > > 8-CPU image.  This commit therefore creates rcuo kthreads only for
>>> > > those CPUs that actually come online.
>>> > > 
>>> > > Reported-by: derRichard
>>> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> > 
>> > Hey Paul,
>> > 
>> > Me again. :)
>> > 
>> > It seems that this patch moved thread initialization to a point way
>> > too early during boot, before rest_init() which initializes kthreadd_task
>> > runs, so creating a new kthread triggers a NULL ptr deref:
> This should be fixed by commit 918179699e4a in -rcu.  My guess is that
> you are instead using commit c6e2955266d14, which, said to say, made it
> into -next yesterday.  :-(
> 
> If my guess is wrong, please let me know!

Your guess is correct.

I'll wait for the next -next tree and retry.


Thanks,
Sasha
