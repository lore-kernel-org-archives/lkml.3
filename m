Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaBQBzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:55:52 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45577 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaBQBzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:55:51 -0500
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
Subject: [PATCH v2 0/11] remove cpu_load in rq 
Date: Mon, 17 Feb 2014 09:55:06 +0800
Message-Id: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_load decays on time according past cpu load of rq. The sched_avg also decays tasks' load on time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load by decay calculation. This patch try to remove the cpu_load decay.

There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change.

V2,
1, This version do some tuning on load bias of target load, to maximum match current code logical.
2, Got further to remove the cpu_load in rq.
3, Revert the patch 'Limit sd->*_idx range on sysctl' since no needs

Any testing/comments are appreciated.

This patch rebase on latest tip/master.
The git tree for this patchset at:
 git@github.com:alexshi/power-scheduling.git noload

Thanks
Alex

