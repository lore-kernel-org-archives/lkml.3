Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3GVOWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:22:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8691 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab3GVOVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:21:30 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uWjsD_7o59IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NHmTPVIv_NYA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=CjxXgO3LAAAA:8 a=bmZwhWPyc9kfCdDqrCcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130722142126.380603777@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Jul 2013 10:20:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 13/14] tracing: Kill trace_array->waiter
References: <20130722141947.972915744@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Kill-trace_array-waiter.patch
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


