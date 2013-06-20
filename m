Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab3FTDgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:36:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935546Ab3FTDgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:41 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FHnwmK1dlrgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=luqOVE7-_nYA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=_H1pvjWkhAEXcDKZHY8A:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033638.939051261@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Subject: [for-next][PATCH 03/12] tracing/trivial: Consolidate error return condition
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-trivial-Consolidate-error-return-condition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>

Consolidate the checks for !enabled and !param to return -EINVAL
in event_enable_func().

Link: http://lkml.kernel.org/r/1369380137-12452-1-git-send-email-harsh@linux.vnet.ibm.com

Signed-off-by: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 27963e2..db086f1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2011,10 +2011,7 @@ event_enable_func(struct ftrace_hash *hash,
 	int ret;
 
 	/* hash funcs only work with set_ftrace_filter */
-	if (!enabled)
-		return -EINVAL;
-
-	if (!param)
+	if (!enabled || !param)
 		return -EINVAL;
 
 	system = strsep(&param, ":");
-- 
1.7.10.4


