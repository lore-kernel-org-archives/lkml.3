Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3EIFrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:47:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42670 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3EIFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:47:06 -0400
X-AuditID: 85900ec0-d4ccab900000151e-8f-518b3857e017
Subject: [PATCH 05/11] tracing: Indicate enabled soft-mode in enable file
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:26 +0900
Message-ID: <20130509054426.30398.28202.stgit@mhiramat-M0-7522>
In-Reply-To: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indicate enabled soft-mode event as "1*" in "enable" file
for each event, because it can be soft-disabled when disable_event
trigger is hit.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
---
 kernel/trace/trace_events.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 44ac836..cc3c130 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -623,6 +623,8 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 	if (file->flags & FTRACE_EVENT_FL_ENABLED) {
 		if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED)
 			buf = "0*\n";
+		else if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
+			buf = "1*\n";
 		else
 			buf = "1\n";
 	} else

