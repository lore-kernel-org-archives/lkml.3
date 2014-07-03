Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbaGCQ1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:27:15 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48358 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbaGCQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:27:12 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 17/23] sched: Likely idle state statistics placeholder
Date: Thu,  3 Jul 2014 17:26:04 +0100
Message-Id: <1404404770-323-18-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:20.0272 (UTC) FILETIME=[85BBDF00:01CF96DB]
X-MC-Unique: 114070317262108801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GRLVD010643

The scheduler is currently completely unaware of idle-states. To make
informed decisions using the sched_group_energy idle_states list it
is necessary to know which idle-state a cpu (or group of cpus) is most
likely to be in when it is idle.

For example when migrating a task that wakes up periodically, the wakeup
energy expense depends on the idle-state the destination cpu is most
likely to be in when idle.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9720f04..353e2d0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4254,6 +4254,19 @@ static inline bool energy_aware(void)
 	return sched_feat(ENERGY_AWARE);
 }
 
+/*
+ * Returns the index of the most likely idle-state that the sched_group is in
+ * when idle. The index can be used to identify the idle-state in the
+ * sched_group_energy idle_states list.
+ *
+ * This is currently just a placeholder. The information needs to come from
+ * cpuidle.
+ */
+static inline int likely_idle_state_idx(struct sched_group *sg)
+{
+	return 0;
+}
+
 static int wake_wide(struct task_struct *p)
 {
 	int factor = this_cpu_read(sd_llc_size);
-- 
1.7.9.5


