Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaFKCB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:01:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:11842 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753294AbaFKCBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:01:13 -0400
Message-Id: <20140611020108.185828250@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 10 Jun 2014 21:59:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 2/4] tracing: Cleanup saved_cmdlines_size changes
References: <20140611015948.013451560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-Cleanup-saved_cmdlines_size-changes.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The recent addition of saved_cmdlines_size file had some remaining
(minor - mostly coding style) issues.  Fix them by passing pointer
name to sizeof() and using scnprintf().

Link: http://lkml.kernel.org/p/1402384295-23680-1-git-send-email-namhyung@kernel.org

Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 56422f1decba..2b458c60e0da 100644
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
2.0.0.rc2


