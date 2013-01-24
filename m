Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AXUN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:13:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50189 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3AXUIw (ORCPT
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
Subject: [PATCH 63/74] perf ui browsers: Fix usage of __ in struct names
Date: Thu, 24 Jan 2013 17:08:12 -0300
Message-Id: <1359058103-31645-64-git-send-email-acme@infradead.org>
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
-- 
1.8.1.1.361.gec3ae6e

