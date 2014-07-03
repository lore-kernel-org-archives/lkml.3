Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbaGCQPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:15:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:3822 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759216AbaGCQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:29 -0400
Message-Id: <20140703161226.109067423@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 15/21] ftrace: Fix memory leak on failure path in ftrace_allocate_pages()
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0015-ftrace-Fix-memory-leak-on-failure-path-in-ftrace_all.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

As struct ftrace_page is managed in a single linked list, it should
free from the start page.

Link: http://lkml.kernel.org/p/1402474014-28655-1-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 39df3192e725..e14ff4c1713e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2637,7 +2637,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	return start_pg;
 
  free_pages:
-	while (start_pg) {
+	pg = start_pg;
+	while (pg) {
 		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
 		free_pages((unsigned long)pg->records, order);
 		start_pg = pg->next;
-- 
2.0.0


