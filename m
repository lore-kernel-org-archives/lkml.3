Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaHKFbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:31:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:13915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaHKFbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:31:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="583018598"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 11/23] perf: Add itrace_config to the event attribute
Date: Mon, 11 Aug 2014 08:19:40 +0300
Message-Id: <1407734392-31097-12-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To configure itrace events, we use a separate config field in the attribute,
which can be used by normal and sampling counters. The latter will use config
to specify the actual event and itrace_config for itrace configuration that
will be used for sampling.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h      | 1 +
 include/uapi/linux/perf_event.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 94961c73e0..cb8c92e041 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -173,6 +173,7 @@ struct perf_event;
 #define PERF_PMU_CAP_AUX_NO_SG			0x02
 #define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
 #define PERF_PMU_CAP_EXCLUSIVE			0x08
+#define PERF_PMU_CAP_ITRACE			0x10
 
 /**
  * struct pmu - generic performance monitoring unit
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 507b5e1f5b..b14b1f57c1 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -239,6 +239,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
 					/* add: aux_watermark */
+#define PERF_ATTR_SIZE_VER4	104	/* add: itrace_config */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -337,6 +338,11 @@ struct perf_event_attr {
 	 * Wakeup watermark for AUX area
 	 */
 	__u32	aux_watermark;
+
+	/*
+	 * Itrace pmus' event config
+	 */
+	__u64	itrace_config;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
-- 
2.1.0.rc1

