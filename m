Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaCTDAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:00:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32197 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750917AbaCTDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:00:11 -0400
Message-Id: <20140320030010.213960780@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Mar 2014 22:58:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [for-next][PATCH 4/4] ftrace: Constify ftrace_text_reserved
References: <20140320025831.285817697@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-ftrace-Constify-ftrace_text_reserved.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

Link: http://lkml.kernel.org/r/1357772960-4436-5-git-send-email-sasha.levin@oracle.com

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 4 ++--
 kernel/trace/ftrace.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 20da0561..9212b01 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -299,7 +299,7 @@ extern void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
 extern void unregister_ftrace_function_probe_all(char *glob);
 
-extern int ftrace_text_reserved(void *start, void *end);
+extern int ftrace_text_reserved(const void *start, const void *end);
 
 extern int ftrace_nr_registered_ops(void);
 
@@ -552,7 +552,7 @@ static inline __init int unregister_ftrace_command(char *cmd_name)
 {
 	return -EINVAL;
 }
-static inline int ftrace_text_reserved(void *start, void *end)
+static inline int ftrace_text_reserved(const void *start, const void *end)
 {
 	return 0;
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b4531b2..1fd4b94 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1555,7 +1555,7 @@ unsigned long ftrace_location(unsigned long ip)
  * the function tracer. It checks the ftrace internal tables to
  * determine if the address belongs or not.
  */
-int ftrace_text_reserved(void *start, void *end)
+int ftrace_text_reserved(const void *start, const void *end)
 {
 	unsigned long ret;
 
-- 
1.8.5.3


