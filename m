Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3AUVVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:21:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3AUVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:29 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uNRa-6cmQqkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rueMwC4KXdUA:10 a=20KFwNOVAAAA:8 a=o-4zwRqDVoAtTrRDUy8A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211728.329781230@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/13 -next] tracing: Remove unneeded check of max_tr->buffer before
 tracing_reset
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Remove-unneeded-check-of-max_tr-buffer-befor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's now a check in tracing_reset_online_cpus() if the buffer is
allocated or NULL. No need to do a check before calling it with max_tr.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 72b171b..d62248d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4040,8 +4040,7 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	 * Reset the buffer so that it doesn't have incomparable timestamps.
 	 */
 	tracing_reset_online_cpus(&global_trace);
-	if (max_tr.buffer)
-		tracing_reset_online_cpus(&max_tr);
+	tracing_reset_online_cpus(&max_tr);
 
 	mutex_unlock(&trace_types_lock);
 
-- 
1.7.10.4


