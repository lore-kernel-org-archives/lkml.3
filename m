Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3DRJRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:17:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40089 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3DRJRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 21/72] ftrace: Consistently restore trace function on sysctl enabling
Date: Thu, 18 Apr 2013 10:16:06 +0100
Message-Id: <1366276617-3553-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 5000c418840b309251c5887f0b56503aae30f84c upstream.

If we reenable ftrace via syctl, we currently set ftrace_trace_function
based on the previous simplistic algorithm. This is inconsistent with
what update_ftrace_function does. So better call that helper instead.

Link: http://lkml.kernel.org/r/5151D26F.1070702@siemens.com

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ftrace.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1b6ec54..00ea125 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4375,12 +4375,8 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
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
1.8.1.2

