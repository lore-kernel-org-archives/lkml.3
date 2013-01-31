Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3AaSl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:41:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab3AaSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:53 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672832"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/13] workqueue: remove WORK_CPU_NONE
Date: Fri, 1 Feb 2013 02:41:24 +0800
Message-Id: <1359657696-2767-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:42,
	Serialize complete at 2013/02/01 02:40:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __next_wq_cpu() for_each_*wq_cpu(), the name WORK_CPU_LAST
is proper than WORK_CPU_NONE, convert them to WORK_CPU_LAST.

WORK_CPU_NONE is not used any more, just remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    3 +--
 kernel/workqueue.c        |    8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a94e4e8..2dcbacc 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -57,8 +57,7 @@ enum {
 
 	/* special cpu IDs */
 	WORK_CPU_UNBOUND	= NR_CPUS,
-	WORK_CPU_NONE		= NR_CPUS + 1,
-	WORK_CPU_LAST		= WORK_CPU_NONE,
+	WORK_CPU_LAST		= NR_CPUS + 1,
 
 	/*
 	 * Reserve 7 bits off of cwq pointer w/ debugobjects turned
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 577de10..973b290 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -258,7 +258,7 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 		if (sw & 2)
 			return WORK_CPU_UNBOUND;
 	}
-	return WORK_CPU_NONE;
+	return WORK_CPU_LAST;
 }
 
 static inline int __next_cwq_cpu(int cpu, const struct cpumask *mask,
@@ -282,17 +282,17 @@ static inline int __next_cwq_cpu(int cpu, const struct cpumask *mask,
  */
 #define for_each_wq_cpu(cpu)						\
 	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
-	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) < WORK_CPU_LAST;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, 3))
 
 #define for_each_online_wq_cpu(cpu)					\
 	for ((cpu) = __next_wq_cpu(-1, cpu_online_mask, 3);		\
-	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) < WORK_CPU_LAST;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
 
 #define for_each_cwq_cpu(cpu, wq)					\
 	for ((cpu) = __next_cwq_cpu(-1, cpu_possible_mask, (wq));	\
-	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) < WORK_CPU_LAST;					\
 	     (cpu) = __next_cwq_cpu((cpu), cpu_possible_mask, (wq)))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
-- 
1.7.7.6

