Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3EFBqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:46:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:64038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab3EFBqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:46:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,618,1363158000"; 
   d="scan'208";a="308658581"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH v5 0/7] use runnable load avg in load balance
Date: Mon,  6 May 2013 09:45:04 +0800
Message-Id: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset bases on tip/sched/core.

It fixed a UP config bug. And the last of patch changed, it insert the
runnable load avg into effective_load(), thus the wake_affine consider 
load avg via effective_load.

I retested on Intel core2, NHM, SNB, IVB, 2 and 4 sockets machines with
benchmark kbuild, aim7, dbench, tbench, hackbench, fileio-cfq(sysbench),
and tested pthread_cond_broadcast on SNB.

The test result is similar with last version. So, clear changes is same:
On SNB EP 4 sockets machine, the hackbench increased about 50%, and result
become stable. on other machines, hackbench increased about 2~5%.
no clear performance change on other benchmarks.

Since the change is small, and my results is similar with last, guess Michael
and Morten still can keep the advantages. 

Anyway, for last version result of them, you can find:
https://lkml.org/lkml/2013/4/2/1022
Michael Wang had tested previous version on pgbench on his box:

http://comments.gmane.org/gmane.linux.kernel/1463371
Morten tested previous version with some benchmarks.
 
Thanks again for Peter's comments!

Regards!
Alex

 [PATCH v5 1/7] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 [PATCH v5 2/7] sched: remove SMP cover for runnable variables in
 [PATCH v5 3/7] sched: set initial value of runnable avg for new
 [PATCH v5 4/7] sched: update cpu load after task_tick.
 [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and
 [PATCH v5 6/7] sched: consider runnable load average in move_tasks
 [PATCH v5 7/7] sched: consider runnable load average in
