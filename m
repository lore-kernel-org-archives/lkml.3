Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbaGCQdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:33:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44877 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaGCQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:09 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 02/23] sched: Make energy awareness a sched feature
Date: Thu,  3 Jul 2014 17:25:49 +0100
Message-Id: <1404404770-323-3-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:07.0444 (UTC) FILETIME=[7E167940:01CF96DB]
X-MC-Unique: 114070317260715001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GX555010753

This patch introduces the ENERGY_AWARE sched feature, which is
implemented using jump labels when SCHED_DEBUG is defined. It is
statically set false when SCHED_DEBUG is not defined. Hence this doesn't
allow energy awareness to be enabled without SCHED_DEBUG. This
sched_feature knob will be replaced later with a more appropriate
control knob when things have matured a bit.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c     |    5 +++++
 kernel/sched/features.h |    6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d3c73122..981406e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4215,6 +4215,11 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 
 #endif
 
+static inline bool energy_aware(void)
+{
+	return sched_feat(ENERGY_AWARE);
+}
+
 static int wake_wide(struct task_struct *p)
 {
 	int factor = this_cpu_read(sd_llc_size);
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
1.7.9.5


