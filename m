Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3HVHsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:48:14 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41804 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3HVHsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:48:12 -0400
Message-ID: <5215C233.9060907@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:48:03 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/11] sched/cleanup: scheduler related cleanup and refine
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-9574-0000-0000-000009490452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set will cleanup and refine the code related to scheduler and
save few lines.

Rough tested (random benchmark) with latest tip/master on a desktop.

Michael Wang (11):
	[PATCH 01/11] sched/cleanup: remove the extra line in init_sched_fair_class()
	[PATCH 02/11] sched/cleanup: remove the extra parm of alloc_thread_info_node()
	[PATCH 03/11] sched/cleanup: remove the extra parm of copy_flags()
	[PATCH 04/11] sched/cleanup: refine rt_policy()
	[PATCH 05/11] sched/cleanup: remove the extra parm of wakeup_gran()
	[PATCH 06/11] sched/cleanup: refine __setup_irq()
	[PATCH 07/11] sched/cleanup: remove the extra parm of irq_set_thread_affinity()
	[PATCH 08/11] sched/cleanup: remove the extra parm of sched_clock_idle_wakeup_event()
	[PATCH 09/11] sched/cleanup: remove the extra parm of tick_nohz_start_idle()
	[PATCH 10/11] sched/cleanup: remove the extra parm of retrigger_next_event()
	[PATCH 11/11] sched/cleanup: remove the extra parm of find_new_ilb()
---
 b/arch/x86/kernel/tsc.c         |    2 +-
 b/drivers/acpi/processor_idle.c |    4 ++--
 b/include/linux/sched.h         |    7 ++-----
 b/kernel/fork.c                 |    8 +++-----
 b/kernel/hrtimer.c              |    8 ++++----
 b/kernel/irq/internals.h        |    2 +-
 b/kernel/irq/manage.c           |    6 ++----
 b/kernel/irq/migration.c        |    2 +-
 b/kernel/sched/clock.c          |    2 +-
 b/kernel/sched/fair.c           |    1 -
 b/kernel/sched/sched.h          |    4 +---
 b/kernel/time/tick-sched.c      |    2 +-
 kernel/fork.c                   |    4 ++--
 kernel/irq/manage.c             |    7 +++----
 kernel/sched/fair.c             |    8 ++++----
 kernel/time/tick-sched.c        |    4 ++--
 16 files changed, 30 insertions(+), 41 deletions(-)

