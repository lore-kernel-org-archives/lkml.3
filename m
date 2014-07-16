Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997AbaGPTPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:15:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760682AbaGPTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:31 -0400
Date: Wed, 16 Jul 2014 12:13:52 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-otc3ployokfci5qi81o7jo22@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Introduce gotorc method
Git-Commit-ID: ca3ff33b5c2dc67daa8d4d130e3bd6231fcb3d14
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

Commit-ID:  ca3ff33b5c2dc67daa8d4d130e3bd6231fcb3d14
Gitweb:     http://git.kernel.org/tip/ca3ff33b5c2dc67daa8d4d130e3bd6231fcb3d14
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Jul 2014 16:42:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 12:36:54 -0300

perf hists browser: Introduce gotorc method

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
index e16aff4..ca63564 100644
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
