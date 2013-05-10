Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3EJPRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:17:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:13258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab3EJPRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:17:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334910944"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [patch 0/8]: use runnable load avg in balance
Date: Fri, 10 May 2013 23:17:21 +0800
Message-Id: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset bases on tip/sched/core.

This version changed the runnable load avg value setting for new task
in patch 3rd.

We also tried to include blocked load avg in balance. but find many benchmark
performance dropping. Guess the too bigger cpu load drive task to be waken
on remote CPU, and cause wrong decision in periodic balance.

I retested on Intel core2, NHM, SNB, IVB, 2 and 4 sockets machines with
benchmark kbuild, aim7, dbench, tbench, hackbench, oltp, and netperf loopback
etc. The performance is better now. 

On SNB EP 4 sockets machine, the hackbench increased about 50%, and result
become stable. on other machines, hackbench increased about 2~10%.
oltp increased about 30% in NHM EX box.
netperf loopback also increased on SNB EP 4 sockets box.
no clear changes on other benchmarks.
 
Michael Wang had tested previous version on pgbench on his box:
https://lkml.org/lkml/2013/4/2/1022

And Morten tested previous version too.
http://comments.gmane.org/gmane.linux.kernel/1463371

Thanks comments from Peter, Paul, Morten, Miacheal and Preeti.
And more comments are appreciated!

Regards
Alex

[patch v6 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
[patch v6 2/8] sched: move few runnable tg variables into CONFIG_SMP
[patch v6 3/8] sched: set initial value of runnable avg for new
[patch v6 4/8] sched: fix slept time double counting in enqueue
[patch v6 5/8] sched: update cpu load after task_tick.
[patch v6 6/8] sched: compute runnable load avg in cpu_load and
[patch v6 7/8] sched: consider runnable load average in move_tasks
[patch v6 8/8] sched: remove blocked_load_avg in tg
