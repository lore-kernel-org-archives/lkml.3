Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaBXFMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:12:41 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54657 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBXFMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:12:39 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH V3 0/10] sched: remove cpu_load
Date: Mon, 24 Feb 2014 13:12:15 +0800
Message-Id: <1393218745-8795-1-git-send-email-alex.shi@linaro.org>
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
patch. just one line patch for this change.

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

