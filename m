Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3AWUgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:36:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3AWUef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:35 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5Iuxg0N2fD0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QbxAS30H2zUA:10 a=20KFwNOVAAAA:8 a=UzZgyjnE_CzGA0SsC-MA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130123203433.987298272@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 23 Jan 2013 15:30:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/12 -next] ftrace: Fix function tracing recursion self test
References: <20130123203002.957226869@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Fix-function-tracing-recursion-self-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function tracing recursion self test should not crash
the machine if the resursion test fails. If it detects that
the function tracing is recursing when it should not be, then
bail, don't go into an infinite recursive loop.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index adb008a..51c819c 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -415,7 +415,8 @@ static void trace_selftest_test_recursion_func(unsigned long ip,
 	 * The ftrace infrastructure should provide the recursion
 	 * protection. If not, this will crash the kernel!
 	 */
-	trace_selftest_recursion_cnt++;
+	if (trace_selftest_recursion_cnt++ > 10)
+		return;
 	DYN_FTRACE_TEST_NAME();
 }
 
-- 
1.7.10.4


