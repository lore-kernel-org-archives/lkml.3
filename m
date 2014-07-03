Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbaGCQSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:18:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759133AbaGCQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:25 -0400
Message-Id: <20140703161223.769550970@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 02/21] ftrace: Use macros for numbers in ftrace rec shift bits
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-ftrace-Use-macros-for-numbers-in-ftrace-rec-shift-bi.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As new flags will be added to the ftrace dynamic record, and since
the flags field is also a counter, converting the numbers used to
do the shifting and masking into a set of macros where we only need
to deal with the max bit count of the counter and the number of bits
for the flags will prevent mistakes in the future.

Dealing with only two numbers is much easier than updating all the
macros that deal with shifting and masking.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 404a686a3644..e4e7df422021 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -322,8 +322,11 @@ enum {
 	FTRACE_FL_REGS_EN	= (1UL << 31)
 };
 
-#define FTRACE_FL_MASK		(0x7UL << 29)
-#define FTRACE_REF_MAX		((1UL << 29) - 1)
+#define FTRACE_REF_MAX_SHIFT	29
+#define FTRACE_FL_BITS		3
+#define FTRACE_FL_MASKED_BITS	((1UL << FTRACE_FL_BITS) - 1)
+#define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
+#define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
 
 struct dyn_ftrace {
 	unsigned long		ip; /* address of mcount call-site */
-- 
2.0.0


