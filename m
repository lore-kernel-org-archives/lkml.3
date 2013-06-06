Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3FFWck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:32:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3FFWbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:31:44 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7q1wy9L8wJoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0tthgu-yfQ4A:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=rp8sQ_PGhaDcVZ7OaiUA:9 a=jeBq3FmKZ4MA:10 a=dGJ0OcVc7YAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130606223142.328223027@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Jun 2013 18:29:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 3/4 (no gpg)] tracing: Fix bad parameter passed in branch selftest
References: <20130606222924.366792086@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Fix-bad-parameter-passed-in-branch-selftest.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The branch selftest calls trace_test_buffer(), but with the new code
it expects the first parameter to be a pointer to a struct trace_buffer.
All self tests were changed but the branch selftest was missed.

This caused either a crash or failed test when the branch selftest was
enabled.

Link: http://lkml.kernel.org/r/20130529141333.GA24064@localhost

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 55e2cf6..2901e3b 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1159,7 +1159,7 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check the trace buffer */
-	ret = trace_test_buffer(tr, &count);
+	ret = trace_test_buffer(&tr->trace_buffer, &count);
 	trace->reset(tr);
 	tracing_start();
 
-- 
1.7.10.4


