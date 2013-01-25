Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3AYMGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:06:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3AYMG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:06:27 -0500
Date: Fri, 25 Jan 2013 04:05:54 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-3gu6vhyro22ywqcldy0gtegv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf pmu: Privatize perf_pmu_{format,
 alias} structs
Git-Commit-ID: ab1bf653220b37927b838df81042c8355d20bc49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:06:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab1bf653220b37927b838df81042c8355d20bc49
Gitweb:     http://git.kernel.org/tip/ab1bf653220b37927b838df81042c8355d20bc49
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 18 Jan 2013 17:05:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:51 -0300

perf pmu: Privatize perf_pmu_{format,alias} structs

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
