Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3AXUNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:13:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3AXUIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 62/74] perf pmu: Fix usage of __ in struct names
Date: Thu, 24 Jan 2013 17:08:11 -0300
Message-Id: <1359058103-31645-63-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In tools/perf we use a convention where __ separates the struct name
from the function name for functions that operate on a struct instance.

Fix this usage by removing it from the struct names and fix also the
associated functions.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1tepcpohpvfg589pizx7tlkq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 20 ++++++++++----------
 tools/perf/util/pmu.h |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index c107e24b..244edbb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -85,7 +85,7 @@ static int pmu_format(char *name, struct list_head *format)
 
 static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
 {
-	struct perf_pmu__alias *alias;
+	struct perf_pmu_alias *alias;
 	char buf[256];
 	int ret;
 
@@ -172,7 +172,7 @@ static int pmu_aliases(char *name, struct list_head *head)
 	return 0;
 }
 
-static int pmu_alias_terms(struct perf_pmu__alias *alias,
+static int pmu_alias_terms(struct perf_pmu_alias *alias,
 			   struct list_head *terms)
 {
 	struct parse_events_term *term, *clone;
@@ -360,10 +360,10 @@ struct perf_pmu *perf_pmu__find(char *name)
 	return pmu_lookup(name);
 }
 
-static struct perf_pmu__format*
+static struct perf_pmu_format *
 pmu_find_format(struct list_head *formats, char *name)
 {
-	struct perf_pmu__format *format;
+	struct perf_pmu_format *format;
 
 	list_for_each_entry(format, formats, list)
 		if (!strcmp(format->name, name))
@@ -405,7 +405,7 @@ static int pmu_config_term(struct list_head *formats,
 			   struct perf_event_attr *attr,
 			   struct parse_events_term *term)
 {
-	struct perf_pmu__format *format;
+	struct perf_pmu_format *format;
 	__u64 *vp;
 
 	/*
@@ -471,10 +471,10 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 	return perf_pmu__config_terms(&pmu->format, attr, head_terms);
 }
 
-static struct perf_pmu__alias *pmu_find_alias(struct perf_pmu *pmu,
-					      struct parse_events_term *term)
+static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
+					     struct parse_events_term *term)
 {
-	struct perf_pmu__alias *alias;
+	struct perf_pmu_alias *alias;
 	char *name;
 
 	if (parse_events__is_hardcoded_term(term))
@@ -508,7 +508,7 @@ static struct perf_pmu__alias *pmu_find_alias(struct perf_pmu *pmu,
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms)
 {
 	struct parse_events_term *term, *h;
-	struct perf_pmu__alias *alias;
+	struct perf_pmu_alias *alias;
 	int ret;
 
 	list_for_each_entry_safe(term, h, head_terms, list) {
@@ -527,7 +527,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms)
 int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits)
 {
-	struct perf_pmu__format *format;
+	struct perf_pmu_format *format;
 
 	format = zalloc(sizeof(*format));
 	if (!format)
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index a313ed7..e881dd1 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -12,14 +12,14 @@ enum {
 
 #define PERF_PMU_FORMAT_BITS 64
 
-struct perf_pmu__format {
+struct perf_pmu_format {
 	char *name;
 	int value;
 	DECLARE_BITMAP(bits, PERF_PMU_FORMAT_BITS);
 	struct list_head list;
 };
 
-struct perf_pmu__alias {
+struct perf_pmu_alias {
 	char *name;
 	struct list_head terms;
 	struct list_head list;
@@ -42,7 +42,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 			   struct list_head *head_terms);
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
-				struct list_head *head_terms);
+				  struct list_head *head_terms);
 int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
 
-- 
1.8.1.1.361.gec3ae6e

