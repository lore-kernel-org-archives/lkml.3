Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbaGCQRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:17:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:3822 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759187AbaGCQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:28 -0400
Message-Id: <20140703161225.633999931@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [for-next][PATCH 12/21] tracing: Remove unnecessary null test before debugfs_remove()
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0012-tracing-Remove-unnecessary-null-test-before-debugfs_.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

This fixes checkpatch warning:

"WARNING: debugfs_remove(NULL) is safe this check is probably not required"
Link: http://lkml.kernel.org/p/1403802871-8599-1-git-send-email-fabf@skynet.be

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eeb233cbac4f..4caa814d41c3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6071,10 +6071,8 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
 	if (!topts)
 		return;
 
-	for (cnt = 0; topts[cnt].opt; cnt++) {
-		if (topts[cnt].entry)
-			debugfs_remove(topts[cnt].entry);
-	}
+	for (cnt = 0; topts[cnt].opt; cnt++)
+		debugfs_remove(topts[cnt].entry);
 
 	kfree(topts);
 }
-- 
2.0.0


