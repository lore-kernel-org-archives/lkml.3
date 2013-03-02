Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3CBDAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:00:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3CBDAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:00:51 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jqditeOjDjcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7TNdVrmWoqgA:10 a=E68sOxnRhrYefrQl8mkA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130302030050.603163000@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Mar 2013 21:48:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 4/7] tracing: Do not block on splice if either file or splice NONBLOCK
 flag is set
References: <20130302024833.624729274@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Do-not-block-on-splice-if-either-file-or-spl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently only the splice NONBLOCK flag is checked to determine if
the splice read should block or not. But the file descriptor NONBLOCK
flag also needs to be checked.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b36befa..00e5e6e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4543,7 +4543,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
 	/* did we read anything? */
 	if (!spd.nr_pages) {
-		if (flags & SPLICE_F_NONBLOCK)
+		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK))
 			ret = -EAGAIN;
 		else
 			ret = 0;
-- 
1.7.10.4


