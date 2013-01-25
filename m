Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3AYMBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:01:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3AYMBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:01:47 -0500
Date: Fri, 25 Jan 2013 04:01:12 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-1tepcpohpvfg589pizx7tlkq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf pmu: Fix usage of __ in struct names
Git-Commit-ID: 5c6ccc3755650497234f9027a0ac9e3b2cf1ba9f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:01:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c6ccc3755650497234f9027a0ac9e3b2cf1ba9f
Gitweb:     http://git.kernel.org/tip/5c6ccc3755650497234f9027a0ac9e3b2cf1ba9f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 18 Jan 2013 16:54:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:50 -0300

perf pmu: Fix usage of __ in struct names

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
 
