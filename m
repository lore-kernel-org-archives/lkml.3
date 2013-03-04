Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab3CDR1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:27:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3CDR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:26:18 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Z26JOTdOi2wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5zRmXlVdhMMA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=dh2Fm6TgEgDkLj4COloA:9 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130304172615.854478479@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 12:20:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [for-next][PATCH 4/6] tracing: Add __per_cpu annotation to trace array percpu data pointer
References: <20130304172005.362537932@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Add-__per_cpu-annotation-to-trace-array-perc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

With the conversion of the data array to per cpu, sparse now complains
about the use of per_cpu_ptr() on the variable. But The variable is
allocated with alloc_percpu() and is fine to use. But since the structure
that contains the data variable does not annotate it as such, sparse
gives out a lot of false warnings.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c597523..50a9c81 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -198,7 +198,7 @@ struct trace_array {
 	struct list_head	systems;
 	struct list_head	events;
 	struct task_struct	*waiter;
-	struct trace_array_cpu	*data;
+	struct trace_array_cpu __percpu	*data;
 };
 
 enum {
-- 
1.7.10.4


