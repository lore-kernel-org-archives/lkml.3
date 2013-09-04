Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856Ab3IDOhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:37:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762771Ab3IDOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:04 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6jnj3o-5QEwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0HxU8x3VG1kA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=ayC55rCoAAAA:8 a=_whD2MN1g3_tR11PCDsA:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143701.283063670@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:35:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [for-next][PATCH 06/18] ftrace: Set ftrace internal function tracing RCU safe
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Set-ftrace-internal-function-tracing-RCU-safe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Since none of the internal ftrace function tracing uses RCU in
their callbacks, it is OK to set the global_ops (the one that
they all use) to RCU safe.

Cc: Jiri Olsa <jolsa@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3327aff..caeeda24 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1146,7 +1146,9 @@ static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.notrace_hash		= EMPTY_HASH,
 	.filter_hash		= EMPTY_HASH,
-	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	.flags			= FTRACE_OPS_FL_RECURSION_SAFE |
+				  FTRACE_OPS_FL_INITIALIZED |
+				  FTRACE_OPS_FL_RCU_SAFE,
 	INIT_REGEX_LOCK(global_ops)
 };
 
-- 
1.7.10.4


