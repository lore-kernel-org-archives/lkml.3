Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754AbaFSVOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:34187 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965506AbaFSVOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:32 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/11] perf ui browser: Fix scrollbar refresh row index
Date: Thu, 19 Jun 2014 18:13:48 -0300
Message-Id: <1403212433-2714-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

The ui_browser__gotorc function needs offset from 'y' member, so the row
index has to begin with 0, which happens by accident in current code,
because we display only one header line.

The bug shows when we want to display more than 1 header lines like
columns headers in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403178076-14072-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 3ccf6e14f89b..9d2294efc00c 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -279,7 +279,7 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 {
 	int height = browser->height, h = 0, pct = 0,
 	    col = browser->width,
-	    row = browser->y - 1;
+	    row = 0;
 
 	if (browser->nr_entries > 1) {
 		pct = ((browser->index * (browser->height - 1)) /
-- 
1.9.3

