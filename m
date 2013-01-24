Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3AXUSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:18:06 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54091
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929Ab3AXUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 66/74] perf pmu: Privatize perf_pmu_{format,alias} structs
Date: Thu, 24 Jan 2013 17:08:15 -0300
Message-Id: <1359058103-31645-67-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

They are only used in pmu.c, so no need to make them public in pmu.h.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3gu6vhyro22ywqcldy0gtegv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 14 +++++++++++++-
 tools/perf/util/pmu.h | 13 -------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 244edbb..4c6f9c4 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1,4 +1,3 @@
-
 #include <linux/list.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -11,6 +10,19 @@
 #include "parse-events.h"
 #include "cpumap.h"
 
+struct perf_pmu_alias {
+	char *name;
+	struct list_head terms;
+	struct list_head list;
+};
+
+struct perf_pmu_format {
+	char *name;
+	int value;
+	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
+	struct list_head list;
+};
+
 #define EVENT_SOURCE_DEVICE_PATH "/bus/event_source/devices/"
 
 int perf_pmu_parse(struct list_head *list, char *name);
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index e881dd1..32fe55b 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -12,19 +12,6 @@ enum {
 
 #define PERF_PMU_FORMAT_BITS 64
 
-struct perf_pmu_format {
-	char *name;
-	int value;
-	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
-	struct list_head list;
-};
-
-struct perf_pmu_alias {
-	char *name;
-	struct list_head terms;
-	struct list_head list;
-};
-
 struct perf_pmu {
 	char *name;
 	__u32 type;
-- 
1.8.1.1.361.gec3ae6e

