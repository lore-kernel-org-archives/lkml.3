Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaFFG2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:28:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48502 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaFFG2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:28:48 -0400
X-AuditID: 85900ec0-d312bb9000001514-78-53915f9d6967
Subject: [PATCH ftrace/core] tracing: Remove return value in
 event_trace_self_tests() when top_trace_array() returns NULL
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Fri, 06 Jun 2014 15:28:44 +0900
Message-ID: <20140606062844.7955.61919.stgit@yunodevel>
In-Reply-To: <20140605234623.484afaf8@gandalf.local.home>
References: <20140605234623.484afaf8@gandalf.local.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove return value in event_trace_self_tests() when top_trace_array() returns
NULL because event_trace_self_tests() is void type.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace_events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1349870..f99e0b3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2547,7 +2547,7 @@ static __init void event_trace_self_tests(void)
 
 	tr = top_trace_array();
 	if (!tr)
-		return -ENODEV;
+		return;
 
 	pr_info("Running tests on trace events:\n");
 

