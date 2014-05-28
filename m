Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaE1A1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:27:12 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:53966 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaE1A1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:27:07 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <dev@codyps.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/16] tools/perf: annotate list_head with type info
Date: Tue, 27 May 2014 17:22:01 -0700
Message-Id: <1401236684-10579-7-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401236684-10579-1-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 tools/perf/util/pmu.c | 4 ++--
 tools/perf/util/pmu.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 00a7dcb..906ae40 100644
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
index 8b64125..4a85230 100644
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

