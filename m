Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaB0MIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:08:11 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55444 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaB0MIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:08:10 -0500
Date: Thu, 27 Feb 2014 17:38:01 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: [PATCH 28/46] kernel: Add prototype declaration to header file
 linux/ftrace.h
Message-ID: <5238e052310ffdcaae2287783013afc42d3f7266.1393493277.git.rashika.kheria@gmail.com>
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

Add prototye declaration of function to header file
include/linux/ftrace.h
because it is used by more than one file.

This eliminates the following warning in
kernel/trace/trace_functions_graph.c:
kernel/trace/trace_functions_graph.c:218:15: warning: no previous prototype for ‘ftrace_return_to_handler’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/ftrace.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index da1c31f..c4d1048 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -673,6 +673,7 @@ typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
 typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace);
+unsigned long ftrace_return_to_handler(unsigned long frame_pointer);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
-- 
1.7.9.5

