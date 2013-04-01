Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab3DAMq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:46:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52041 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab3DAMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:46:39 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-20-515981adaed1
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/3] tracing: Fix off-by-one on allocating stat->pages
Date: Mon,  1 Apr 2013 21:46:24 +0900
Message-Id: <1364820385-32027-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364820385-32027-1-git-send-email-namhyung@kernel.org>
References: <1364820385-32027-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The first page was allocated separately, so no need to start from 0.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 65bc47472b1b..d38ad7145f2f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -676,7 +676,7 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 
 	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
 
-	for (i = 0; i < pages; i++) {
+	for (i = 1; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;
-- 
1.7.11.7

