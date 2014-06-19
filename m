Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbaFSLmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbaFSLlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:41:36 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/5] perf tools: Fix scrollbar refresh row index
Date: Thu, 19 Jun 2014 13:41:14 +0200
Message-Id: <1403178076-14072-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ui_browser__gotorc function needs offset from 'y' member,
so the row index has to begin with 0, which happens by accident
in current code, because we display only one header line.

The bug shows when we want to display more than 1 header lines
like columns headers in following patches.

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
 tools/perf/ui/browser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index e6f96be..6792efb 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -285,7 +285,7 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 {
 	int height = browser->height, h = 0, pct = 0,
 	    col = browser->width,
-	    row = browser->y - 1;
+	    row = 0;
 
 	if (browser->nr_entries > 1) {
 		pct = ((browser->index * (browser->height - 1)) /
-- 
1.8.3.1

