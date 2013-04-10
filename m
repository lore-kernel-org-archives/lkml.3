Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936590Ab3DJXMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:12:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937218Ab3DJWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 32/64] ftrace: Consistently restore trace function on sysctl enabling
Date: Wed, 10 Apr 2013 15:46:29 -0700
Message-Id: <20130410224340.579047216@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 5000c418840b309251c5887f0b56503aae30f84c upstream.

If we reenable ftrace via syctl, we currently set ftrace_trace_function
based on the previous simplistic algorithm. This is inconsistent with
what update_ftrace_function does. So better call that helper instead.

Link: http://lkml.kernel.org/r/5151D26F.1070702@siemens.com

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4537,12 +4537,8 @@ ftrace_enable_sysctl(struct ctl_table *t
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


