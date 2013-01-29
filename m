Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3A2Kpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:45:43 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43328 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3A2Kpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:45:41 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 0/2] sched: fix nr_busy_cpus
Date: Tue, 29 Jan 2013 11:38:58 +0100
Message-Id: <1359455940-1710-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_busy_cpus field of the sched_group_power is sometime different from 0
whereas the platform is fully idle. This serie fixes 3 use cases:
 - when some CPUs enter idle state while booting all CPUs
 - when a CPU is unplug and/or replug

Change since V1:
 - remove the patch for SCHED softirq on an idle core use case as it was
   a side effect of the other use cases.

Vincent Guittot (2):
  sched: fix init NOHZ_IDLE flag
  sched: fix update NOHZ_IDLE flag

 kernel/sched/core.c |    1 +
 kernel/sched/fair.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.9.5

