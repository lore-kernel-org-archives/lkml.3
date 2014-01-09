Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaAIXwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:52:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45390 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaAIXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:51:50 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 1/3] perf: comment on usage of perf_invalid_context
Date: Thu,  9 Jan 2014 15:51:30 -0800
Message-Id: <1389311492-5059-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010923-6688-0000-0000-0000055F91CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context numbers less than 0 are treated specially within the events
code, add a comment to document this.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/sched.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53f97eb..f574820 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1033,6 +1033,10 @@ struct sched_rt_entity {
 struct rcu_node;
 
 enum perf_event_task_context {
+	/*
+	 * When <0, allocate a pmu local pmu->pmu_cpu_context (instead
+	 * of sharing among pmus in the same context) and forbid task tracking.
+	 */
 	perf_invalid_context = -1,
 	perf_hw_context = 0,
 	perf_sw_context,
-- 
1.8.5.2

