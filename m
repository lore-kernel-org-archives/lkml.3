Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab3GRTw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:52:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41725 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503Ab3GRTuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 44/76] perf tools: Add const specifier to perf_pmu__find name parameter
Date: Thu, 18 Jul 2013 16:49:31 -0300
Message-Id: <1374177003-3706-45-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The name parameter is constant, declare it so.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372944040-32690-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 14 +++++++-------
 tools/perf/util/pmu.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 4c6f9c4..1d1862d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -73,7 +73,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head)
  * located at:
  * /sys/bus/event_source/devices/<dev>/format as sysfs group attributes.
  */
-static int pmu_format(char *name, struct list_head *format)
+static int pmu_format(const char *name, struct list_head *format)
 {
 	struct stat st;
 	char path[PATH_MAX];
@@ -162,7 +162,7 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
  * Reading the pmu event aliases definition, which should be located at:
  * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
  */
-static int pmu_aliases(char *name, struct list_head *head)
+static int pmu_aliases(const char *name, struct list_head *head)
 {
 	struct stat st;
 	char path[PATH_MAX];
@@ -208,7 +208,7 @@ static int pmu_alias_terms(struct perf_pmu_alias *alias,
  * located at:
  * /sys/bus/event_source/devices/<dev>/type as sysfs attribute.
  */
-static int pmu_type(char *name, __u32 *type)
+static int pmu_type(const char *name, __u32 *type)
 {
 	struct stat st;
 	char path[PATH_MAX];
@@ -266,7 +266,7 @@ static void pmu_read_sysfs(void)
 	closedir(dir);
 }
 
-static struct cpu_map *pmu_cpumask(char *name)
+static struct cpu_map *pmu_cpumask(const char *name)
 {
 	struct stat st;
 	char path[PATH_MAX];
@@ -293,7 +293,7 @@ static struct cpu_map *pmu_cpumask(char *name)
 	return cpus;
 }
 
-static struct perf_pmu *pmu_lookup(char *name)
+static struct perf_pmu *pmu_lookup(const char *name)
 {
 	struct perf_pmu *pmu;
 	LIST_HEAD(format);
@@ -330,7 +330,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 	return pmu;
 }
 
-static struct perf_pmu *pmu_find(char *name)
+static struct perf_pmu *pmu_find(const char *name)
 {
 	struct perf_pmu *pmu;
 
@@ -356,7 +356,7 @@ struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu)
 	return NULL;
 }
 
-struct perf_pmu *perf_pmu__find(char *name)
+struct perf_pmu *perf_pmu__find(const char *name)
 {
 	struct perf_pmu *pmu;
 
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 32fe55b..d17b565 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -21,7 +21,7 @@ struct perf_pmu {
 	struct list_head list;
 };
 
-struct perf_pmu *perf_pmu__find(char *name);
+struct perf_pmu *perf_pmu__find(const char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
 int perf_pmu__config_terms(struct list_head *formats,
-- 
1.8.1.4

