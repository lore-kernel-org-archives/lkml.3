Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840Ab3GSHu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:50:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965788Ab3GSHuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:20 -0400
Date: Fri, 19 Jul 2013 00:49:43 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-b6b96fb48f75d62858b39baf13c83c4504642f15@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1372944040-32690-7-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add const specifier to perf_pmu__find name parameter
Git-Commit-ID: b6b96fb48f75d62858b39baf13c83c4504642f15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:49:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6b96fb48f75d62858b39baf13c83c4504642f15
Gitweb:     http://git.kernel.org/tip/b6b96fb48f75d62858b39baf13c83c4504642f15
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 4 Jul 2013 16:20:25 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:52 -0300

perf tools: Add const specifier to perf_pmu__find name parameter

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
