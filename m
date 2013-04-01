Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3DAMqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:46:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52041 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3DAMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:46:39 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-1f-515981ac2b00
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/3] tracing: Fix double free when function profile init failed
Date: Mon,  1 Apr 2013 21:46:23 +0900
Message-Id: <1364820385-32027-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

On the failure path, stat->start and stat->pages will refer same page.
So it'll attempt to free the same page again and get kernel panic.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 25770824598f..65bc47472b1b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -694,7 +694,6 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 
-- 
1.7.11.7

