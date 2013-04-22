Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3DVOad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:30:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51651 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab3DVOaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kiszka" <jan.kiszka@siemens.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.281813932@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [28/75] ftrace: Consistently restore trace function on sysctl
 enabling
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 5000c418840b309251c5887f0b56503aae30f84c upstream.

If we reenable ftrace via syctl, we currently set ftrace_trace_function
based on the previous simplistic algorithm. This is inconsistent with
what update_ftrace_function does. So better call that helper instead.

Link: http://lkml.kernel.org/r/5151D26F.1070702@siemens.com

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3964,12 +3964,8 @@ ftrace_enable_sysctl(struct ctl_table *t
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

