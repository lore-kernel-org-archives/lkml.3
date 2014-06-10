Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaFJHLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:11:49 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51582 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbaFJHLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:11:48 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH] tracing: Cleanup saved_cmdlines_size changes
Date: Tue, 10 Jun 2014 16:11:35 +0900
Message-Id: <1402384295-23680-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent addition of saved_cmdlines_size file had some remaining
(minor - mostly coding style) issues.  Fix them by passing pointer
name to sizeof() and using scnprintf().

Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 16f7038d1f4d..02f081a45b36 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1338,7 +1338,7 @@ static int trace_create_savedcmd(void)
 {
 	int ret;
 
-	savedcmd = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	savedcmd = kmalloc(sizeof(*savedcmd), GFP_KERNEL);
 	if (!savedcmd)
 		return -ENOMEM;
 
@@ -3840,7 +3840,7 @@ tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
 	int r;
 
 	arch_spin_lock(&trace_cmdline_lock);
-	r = sprintf(buf, "%u\n", savedcmd->cmdline_num);
+	r = scnprintf(buf, sizeof(buf), "%u\n", savedcmd->cmdline_num);
 	arch_spin_unlock(&trace_cmdline_lock);
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
@@ -3857,7 +3857,7 @@ static int tracing_resize_saved_cmdlines(unsigned int val)
 {
 	struct saved_cmdlines_buffer *s, *savedcmd_temp;
 
-	s = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
 
-- 
2.0.0

