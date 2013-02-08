Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946907Ab3BHSGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:06:11 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:42991 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946891Ab3BHSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:06:07 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 0/2] sched: fix nr_busy_cpus
Date: Fri,  8 Feb 2013 19:05:16 +0100
Message-Id: <1360346718-3313-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_busy_cpus field of the sched_group_power is sometime different from 0
whereas the platform is fully idle. This serie fixes 3 use cases:
 - when some CPUs enter idle state while booting all CPUs
 - when a CPU is unplug and/or replug

Change since V2:
 - change the initialization to idle state instead of busy state so a CPU that
   enters idle during the build of the sched_domain will not corrupt the
   initialization state

Change since V1:
 - remove the patch for SCHED softirq on an idle core use case as it was
   a side effect of the other use cases.

Vincent Guittot (2):
  sched: fix init NOHZ_IDLE flag
  sched: fix update NOHZ_IDLE flag

 kernel/sched/core.c |    4 +++-
 kernel/sched/fair.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
1.7.9.5

