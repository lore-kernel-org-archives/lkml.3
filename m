Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3EGEM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:12:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab3EGD6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:46 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bL8IJ0QeHl8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=01gTtZFvT7UA:10 a=a_U1oVfrAAAA:8 a=VwQbUJbxAAAA:8 a=5Up8faWwAAAA:8 a=nnS9Z_ekIDrHSj9FyUoA:9 a=m6r2lrufZtcA:10 a=k4qQewaewV0A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035843.912978930@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Subject: [018/126] ftrace: Consistently restore trace function on sysctl enabling
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0018-ftrace-Consistently-restore-trace-function-on-sysctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit 5000c418840b309251c5887f0b56503aae30f84c ]

If we reenable ftrace via syctl, we currently set ftrace_trace_function
based on the previous simplistic algorithm. This is inconsistent with
what update_ftrace_function does. So better call that helper instead.

Link: http://lkml.kernel.org/r/5151D26F.1070702@siemens.com

Cc: stable@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c27095d..bef5ebc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4353,12 +4353,8 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 		ftrace_startup_sysctl();
 
 		/* we are starting ftrace again */
-		if (ftrace_ops_list != &ftrace_list_end) {
-			if (ftrace_ops_list->next == &ftrace_list_end)
-				ftrace_trace_function = ftrace_ops_list->func;
-			else
-				ftrace_trace_function = ftrace_ops_list_func;
-		}
+		if (ftrace_ops_list != &ftrace_list_end)
+			update_ftrace_function();
 
 	} else {
 		/* stopping ftrace calls (just send to ftrace_stub) */
-- 
1.7.10.4


