Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab3GSOZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3GSOZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:25:38 -0400
Date: Fri, 19 Jul 2013 16:20:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: Kill trace_array->waiter
Message-ID: <20130719142036.GA1594@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial. trace_array->waiter has no users since 6eaaa5d5
"tracing/core: use appropriate waiting on trace_pipe".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4a4f6e1..f849e85 100644
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
1.5.5.1


