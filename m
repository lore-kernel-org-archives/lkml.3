Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaBYBvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:51:17 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39891 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaBYBvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:51:13 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: [PATCH V4 0/11] sched: remove cpu_loads
Date: Tue, 25 Feb 2014 09:50:43 +0800
Message-Id: <1393293054-11378-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_load decays on time according past cpu load of rq. The sched_avg 
also decays tasks' load on time. Now we has 2 kind decay for cpu_load. 
That is a kind of redundancy. And increase the system load by decay 
calculation. This patch try to remove the cpu_load decay.

There are 5 load_idx used for cpu_load in sched_domain. busy_idx and 
idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx 
are all zero on every arch. A shortcut to remove cpu_Load decay in the first
patch. just one line patch for this change. Then I try to clean up code 
followed by this change.


V4,
1, rebase on latest tip/master
2, replace target_load by biased_load as Morten's suggestion

V3,
1, correct the wake_affine bias. Thanks for Morten's reminder!
2, replace source_load by weighted_cpuload for better function name meaning.

V2,
1, This version do some tuning on load bias of target load.
2, Got further to remove the cpu_load in rq.
3, Revert the patch 'Limit sd->*_idx range on sysctl' since no needs

Any testing/comments are appreciated.

This patch rebase on latest tip/master.
The git tree for this patchset at:
 git@github.com:alexshi/power-scheduling.git noload

Thanks
Alex

 [PATCH 01/11] sched: shortcut to remove load_idx
 [PATCH 02/11] sched: remove rq->cpu_load[load_idx] array
 [PATCH 03/11] sched: clean up cpu_load update
 [PATCH 04/11] sched: unify imbalance bias for target group
 [PATCH 05/11] sched: rewrite update_cpu_load_nohz
 [PATCH 06/11] sched: clean up source_load/target_load
 [PATCH 07/11] sched: replace source_load by weighted_cpuload
 [PATCH 08/11] sched: replace target_load by biased_load
 [PATCH 09/11] sched: remove rq->cpu_load and rq->nr_load_updates
 [PATCH 10/11] sched: rename update_*_cpu_load
 [PATCH 11/11] sched: clean up task_hot function
