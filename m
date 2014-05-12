Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbaELPON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:14:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:27486 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758736AbaELPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:07 -0400
Message-Id: <20140512151203.876979870@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 08/13] ftrace: Always inline ftrace_hash_empty() helper function
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0008-ftrace-Always-inline-ftrace_hash_empty-helper-functi.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The ftrace_hash_empty() function is a simple test:

	return !hash || !hash->count;

But gcc seems to want to make it a call. As this is in an extreme
hot path of the function tracer, there's no reason it needs to be
a call. I only wrote it to be a helper function anyway, otherwise
it would have been inlined manually.

Force gcc to inline it, as it could have also been a macro.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 61f39f8..98fa931 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1105,7 +1105,7 @@ struct ftrace_page {
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
 
-static bool ftrace_hash_empty(struct ftrace_hash *hash)
+static bool __always_inline ftrace_hash_empty(struct ftrace_hash *hash)
 {
 	return !hash || !hash->count;
 }
-- 
1.8.5.3


