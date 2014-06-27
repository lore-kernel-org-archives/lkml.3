Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaF0Q1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:27:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaF0Q1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:27:17 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] perf tools tui: Remove width setting from hist_browser__refresh_dimensions
Date: Fri, 27 Jun 2014 18:26:56 +0200
Message-Id: <1403886418-5556-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403886418-5556-1-git-send-email-jolsa@kernel.org>
References: <1403886418-5556-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always use the full width of the screen, so just use the
detected width. Calling ui_browser__refresh_dimensions to
get the current terminal screen scale.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 2185091..8102f45 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -58,9 +58,7 @@ static u32 hist_browser__nr_entries(struct hist_browser *hb)
 
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
-	/* 3 == +/- toggle symbol before actual hist_entry rendering */
-	browser->b.width = 3 + (hists__sort_list_width(browser->hists) +
-			     sizeof("[k]"));
+	ui_browser__refresh_dimensions(&browser->b);
 }
 
 static void hist_browser__reset(struct hist_browser *browser)
-- 
1.8.3.1

