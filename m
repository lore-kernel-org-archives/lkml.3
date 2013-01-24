Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3AXDkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:40:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:14248 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab3AXD37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="247742515"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [ RFC patch 0/4]: use runnable load avg in cfs balance instead of instant load
Date: Thu, 24 Jan 2013 11:30:39 +0800
Message-Id: <1358998243-23176-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset can be used, but causes burst waking benchmark aim9 drop 5~7%
on my 2 sockets machine. The reason is too light runnable load in early stage
of waked tasks cause imbalance in balancing.

So, it is immature and just a reference for guys who want to go gurther.

Thanks!
Alex

[PATCH 1/4] sched: update cpu load after task_tick.
[PATCH 2/4] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
[PATCH 3/4] sched: consider runnable load average in move_tasks
[PATCH 4/4] sched: consider runnable load average in effective_load
