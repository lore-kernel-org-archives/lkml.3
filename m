Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaHOQuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:50:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:44674 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaHOQuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:50:32 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <dev@codyps.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Haren Myneni <hbabu@us.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@lists.ozlabs.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/18] perf tools: Annotate PMU related list_head members with type info
Date: Fri, 15 Aug 2014 13:49:49 -0300
Message-Id: <1408121403-11919-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <dev@codyps.com>

So that we can more readily understand in which list heads structs are
stored into.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1408087583-32239-6-git-send-email-sukadev@linux.vnet.ibm.com
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 4 ++--
 tools/perf/util/pmu.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 7a811eb61f75..9bf582750561 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -14,8 +14,8 @@
 
 struct perf_pmu_alias {
 	char *name;
-	struct list_head terms;
-	struct list_head list;
+	struct list_head terms; /* HEAD struct parse_events_term -> list */
+	struct list_head list;  /* ELEM */
 	char unit[UNIT_MAX_LEN+1];
 	double scale;
 };
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index c14a543ce1f3..1c1e2eecbe1f 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -17,9 +17,9 @@ struct perf_pmu {
 	char *name;
 	__u32 type;
 	struct cpu_map *cpus;
-	struct list_head format;
-	struct list_head aliases;
-	struct list_head list;
+	struct list_head format;  /* HEAD struct perf_pmu_format -> list */
+	struct list_head aliases; /* HEAD struct perf_pmu_alias -> list */
+	struct list_head list;    /* ELEM */
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
-- 
1.9.3

