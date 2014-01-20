Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaATMkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:40:16 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51608 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaATMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:06 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 03/11] sched: define TOPOLOGY_SD_FLAGS
Date: Mon, 20 Jan 2014 12:39:40 +0000
Message-Id: <1390221588-20473-4-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:02.0926 (UTC) FILETIME=[BD4248E0:01CF15DC]
X-MC-Unique: 114012012400400301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCeMlw003774

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

TOPOLOGY_SD_FLAGS contains all SD flags which provide topology related
information towards the scheduler. All other SD flags describe scheduler
behavioural aspects.  The aim of TOPOLOGY_SD_FLAGS is to be able to check
that the arch only specifies topology related flags in the topology info
array.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/sched.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b21d633..fcf2d4317217 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1414,3 +1414,19 @@ static inline u64 irq_time_read(int cpu)
 }
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+/*
+ * SD_flags allowed in topology descriptions.
+ *
+ * SD_SHARE_CPUPOWER      - describes SMT topologies
+ * SD_SHARE_PKG_RESOURCES - describes shared caches
+ * SD_NUMA                - describes NUMA topologies
+ *
+ * Odd one out:
+ * SD_ASYM_PACKING        - describes SMT quirks
+ */
+#define TOPOLOGY_SD_FLAGS         \
+	(SD_SHARE_CPUPOWER |      \
+	 SD_SHARE_PKG_RESOURCES | \
+	 SD_NUMA |                \
+	 SD_ASYM_PACKING)
-- 
1.7.9.5


