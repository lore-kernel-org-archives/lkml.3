Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3AYMDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:03:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42232 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3AYMC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:02:59 -0500
Date: Fri, 25 Jan 2013 04:02:23 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-rfj7acng5tukftb8hy1rrw08@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browsers: Fix usage of __ in struct names
Git-Commit-ID: 7c3102b843a581b4b84643a18d423f8807364ca0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:02:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c3102b843a581b4b84643a18d423f8807364ca0
Gitweb:     http://git.kernel.org/tip/7c3102b843a581b4b84643a18d423f8807364ca0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 18 Jan 2013 16:55:52 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:51 -0300

perf ui browsers: Fix usage of __ in struct names

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
Link: http://lkml.kernel.org/n/tip-rfj7acng5tukftb8hy1rrw08@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c           | 4 ++--
 tools/perf/ui/browsers/annotate.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 4aeb7d5..588bcb2 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -471,7 +471,7 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *browser)
 	return row;
 }
 
-static struct ui_browser__colorset {
+static struct ui_browser_colorset {
 	const char *name, *fg, *bg;
 	int colorset;
 } ui_browser__colorsets[] = {
@@ -706,7 +706,7 @@ void ui_browser__init(void)
 	perf_config(ui_browser__color_config, NULL);
 
 	while (ui_browser__colorsets[i].name) {
-		struct ui_browser__colorset *c = &ui_browser__colorsets[i++];
+		struct ui_browser_colorset *c = &ui_browser__colorsets[i++];
 		sltt_set_color(c->colorset, c->name, c->fg, c->bg);
 	}
 
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 2fc7f04..7dca155 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -926,7 +926,7 @@ out_free_offsets:
 /*
  * Keep the entries sorted, they are bsearch'ed
  */
-static struct annotate__config {
+static struct annotate_config {
 	const char *name;
 	bool *value;
 } annotate__configs[] = {
@@ -940,7 +940,7 @@ static struct annotate__config {
 
 static int annotate_config__cmp(const void *name, const void *cfgp)
 {
-	const struct annotate__config *cfg = cfgp;
+	const struct annotate_config *cfg = cfgp;
 
 	return strcmp(name, cfg->name);
 }
@@ -948,7 +948,7 @@ static int annotate_config__cmp(const void *name, const void *cfgp)
 static int annotate__config(const char *var, const char *value,
 			    void *data __maybe_unused)
 {
-	struct annotate__config *cfg;
+	struct annotate_config *cfg;
 	const char *name;
 
 	if (prefixcmp(var, "annotate.") != 0)
@@ -956,7 +956,7 @@ static int annotate__config(const char *var, const char *value,
 
 	name = var + 9;
 	cfg = bsearch(name, annotate__configs, ARRAY_SIZE(annotate__configs),
-		      sizeof(struct annotate__config), annotate_config__cmp);
+		      sizeof(struct annotate_config), annotate_config__cmp);
 
 	if (cfg == NULL)
 		return -1;
