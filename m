Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaB0MFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:05:05 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37695 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaB0MFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:05:02 -0500
Date: Thu, 27 Feb 2014 17:32:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: [PATCH 25/46] kernel: Add prototype declaration to header file
 include/linux/ftrace.h
Message-ID: <f43d408c30c2a4bd326995992f26f8e727b281d9.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function to header file
include/linux/ftrace.h because it is used by more than one file.

This eliminates the following warning in kernel/trace/ftrace.c:
kernel/trace/ftrace.c:4914:5: warning: no previous prototype for ‘ftrace_graph_entry_stub’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/ftrace.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 68ea184..da1c31f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -672,6 +672,8 @@ struct ftrace_graph_ret {
 typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
 typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
 
+int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace);
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /* for init task */
-- 
1.7.9.5

