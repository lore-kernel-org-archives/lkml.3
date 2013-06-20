Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935574Ab3FTCUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:20:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:36139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935491Ab3FTCUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:20:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="319759141"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [Resend patch v8 0/13] use runnable load in schedule balance
Date: Thu, 20 Jun 2013 10:18:44 +0800
Message-Id: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend patchset for more convenient pick up.
This patch set combine 'use runnable load in balance' serials and 'change 
64bit variables to long type' serials. also collected Reviewed-bys, and 
Tested-bys.

The only changed code is fixing load to load_avg convert in UP mode, which
found by PeterZ in task_h_load().

Paul still has some concern of blocked_load_avg out of balance consideration.
but I didn't see the blocked_load_avg usage was thought through now, or some 
strong reason to make it into balance.
So, according to benchmarks testing result I keep patches unchanged.

Regards
Alex

[Resend patch v8 01/13] Revert "sched: Introduce temporary
[Resend patch v8 02/13] sched: move few runnable tg variables into
[Resend patch v8 03/13] sched: set initial value of runnable avg for
[Resend patch v8 04/13] sched: fix slept time double counting in
[Resend patch v8 05/13] sched: update cpu load after task_tick.
[Resend patch v8 06/13] sched: compute runnable load avg in cpu_load
[Resend patch v8 07/13] sched: consider runnable load average in
[Resend patch v8 08/13] sched/tg: remove blocked_load_avg in balance
[Resend patch v8 09/13] sched: change cfs_rq load avg to unsigned
[Resend patch v8 10/13] sched/tg: use 'unsigned long' for load
[Resend patch v8 11/13] sched/cfs_rq: change atomic64_t removed_load
[Resend patch v8 12/13] sched/tg: remove tg.load_weight
[Resend patch v8 13/13] sched: get_rq_runnable_load() can be static
