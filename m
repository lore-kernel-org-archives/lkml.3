Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3AZBtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:49:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:41584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab3AZBs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:48:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,542,1355126400"; 
   d="scan'208";a="276820836"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [RFC patch v2] sched: use runnable load avg in cfs balance instead of instant load
Date: Sat, 26 Jan 2013 09:49:17 +0800
Message-Id: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset can be used, but causes burst waking benchmark aim9 drop 5~7%
on my 2 sockets machine. The reason is too light runnable load in early stage
of waked tasks causes imbalance in balancing.

So, it is immature and just a reference for guys who want to go gurther.

V2 change:
1, attached the 1~3 patches, which were sent in power awareness scheduling
2, remove CONFIG_FAIR_GROUP_SCHED mask in patch 5th.

Thanks Ingo's comments and testing provided by Fengguang's kbuild system.
Now it is indepent patchset bases on Linus' tree.

Thanks 
Alex

[RFC patch v2 1/7] sched: give initial value for runnable avg of
[RFC patch v2 2/7] sched: set initial load avg of new forked task
[RFC patch v2 3/7] Revert "sched: Introduce temporary
[RFC patch v2 4/7] sched: update cpu load after task_tick.
[RFC patch v2 5/7] sched: compute runnable load avg in cpu_load and
[RFC patch v2 6/7] sched: consider runnable load average in
[RFC patch v2 7/7] sched: consider runnable load average in
