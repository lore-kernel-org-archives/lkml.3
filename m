Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3GTDVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 23:21:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3GTDVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 23:21:48 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2PezdWZZqEwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ns_mWPJDFy4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=bmZwhWPyc9kfCdDqrCcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130720032146.753812735@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 23:20:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 1/2] tracing: Kill trace_array->waiter
References: <20130720032028.963792665@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Kill-trace_array-waiter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Trivial. trace_array->waiter has no users since 6eaaa5d5
"tracing/core: use appropriate waiting on trace_pipe".

Link: http://lkml.kernel.org/r/20130719142036.GA1594@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 57b7bb0..e7d643b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -214,7 +214,6 @@ struct trace_array {
 	struct dentry		*event_dir;
 	struct list_head	systems;
 	struct list_head	events;
-	struct task_struct	*waiter;
 	int			ref;
 };
 
-- 
1.7.10.4


