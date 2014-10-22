Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaJVGIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:08:01 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37157 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJVGHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:07:52 -0400
From: Mike Turquette <mturquette@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 1/7] sched: Make energy awareness a sched feature
Date: Tue, 21 Oct 2014 23:07:25 -0700
Message-Id: <1413958051-7103-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Morten Rasmussen <morten.rasmussen@arm.com>

This patch introduces the ENERGY_AWARE sched feature, which is
implemented using jump labels when SCHED_DEBUG is defined. It is
statically set false when SCHED_DEBUG is not defined. Hence this doesn't
allow energy awareness to be enabled without SCHED_DEBUG. This
sched_feature knob will be replaced later with a more appropriate
control knob when things have matured a bit.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
[mturquette@linaro.org: moved energy_aware above enqueue_task_fair]
---
 kernel/sched/fair.c     | 5 +++++
 kernel/sched/features.h | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6738160..90b36cc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3978,6 +3978,11 @@ static inline void hrtick_update(struct rq *rq)
 }
 #endif
 
+static inline bool energy_aware(void)
+{
+	return sched_feat(ENERGY_AWARE);
+}
+
 /*
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 90284d1..199ee3a 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -83,3 +83,9 @@ SCHED_FEAT(NUMA_FAVOUR_HIGHER, true)
  */
 SCHED_FEAT(NUMA_RESIST_LOWER, false)
 #endif
+
+/*
+ * Energy aware scheduling. Use platform energy model to guide scheduling
+ * decisions optimizing for energy efficiency.
+ */
+SCHED_FEAT(ENERGY_AWARE, false)
-- 
1.8.3.2

