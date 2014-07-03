Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbaGCVnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:43:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:53734 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759633AbaGCVn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:43:28 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/7] perf hists browser: Introduce gotorc method
Date: Thu,  3 Jul 2014 18:42:56 -0300
Message-Id: <1404423780-24026-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404423780-24026-1-git-send-email-acme@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That will allow us to add a row offset to open up space for the column
headers.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-otc3ployokfci5qi81o7jo22@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index e16aff45b564..ca63564d203a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -63,6 +63,11 @@ static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 			     sizeof("[k]"));
 }
 
+static void hist_browser__gotorc(struct hist_browser *browser, int row, int column)
+{
+	ui_browser__gotorc(&browser->b, row, column);
+}
+
 static void hist_browser__reset(struct hist_browser *browser)
 {
 	/*
@@ -508,7 +513,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 			}
 
 			ui_browser__set_color(&browser->b, color);
-			ui_browser__gotorc(&browser->b, row, 0);
+			hist_browser__gotorc(browser, row, 0);
 			slsmg_write_nstring(" ", offset + extra_offset);
 			slsmg_printf("%c ", folded_sign);
 			slsmg_write_nstring(str, width);
@@ -567,7 +572,7 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
 
 		s = callchain_list__sym_name(chain, bf, sizeof(bf),
 					     browser->show_dso);
-		ui_browser__gotorc(&browser->b, row, 0);
+		hist_browser__gotorc(browser, row, 0);
 		ui_browser__set_color(&browser->b, color);
 		slsmg_write_nstring(" ", offset);
 		slsmg_printf("%c ", folded_sign);
@@ -732,7 +737,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.ptr		= &arg,
 		};
 
-		ui_browser__gotorc(&browser->b, row, 0);
+		hist_browser__gotorc(browser, row, 0);
 
 		perf_hpp__for_each_format(fmt) {
 			if (perf_hpp__should_skip(fmt))
-- 
1.9.3

