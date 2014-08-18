Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHRIYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:24:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaHRIYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:24:47 -0400
Date: Mon, 18 Aug 2014 01:22:18 -0700
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-885b5930d6632fc7df55445d9021b87d8bb17a9b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hbabu@us.ibm.com, hpa@zytor.com, mingo@kernel.org,
        michaele@au1.ibm.com, cody@linux.vnet.ibm.com, peterz@infradead.org,
        khandual@linux.vnet.ibm.com, jolsa@redhat.com, dev@codyps.com,
        ak@linux.intel.com, sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, hbabu@us.ibm.com,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        cody@linux.vnet.ibm.com, michaele@au1.ibm.com,
        khandual@linux.vnet.ibm.com, peterz@infradead.org, jolsa@redhat.com,
        ak@linux.intel.com, dev@codyps.com, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
In-Reply-To: <1408087583-32239-6-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1408087583-32239-6-git-send-email-sukadev@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Annotate PMU related list_head members with type info
Git-Commit-ID: 885b5930d6632fc7df55445d9021b87d8bb17a9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  885b5930d6632fc7df55445d9021b87d8bb17a9b
Gitweb:     http://git.kernel.org/tip/885b5930d6632fc7df55445d9021b87d8bb17a9b
Author:     Cody P Schafer <dev@codyps.com>
AuthorDate: Fri, 15 Aug 2014 00:26:14 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:42:40 -0300

perf tools: Annotate PMU related list_head members with type info

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
index 7a811eb..9bf5827 100644
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
index c14a543..1c1e2ee 100644
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
