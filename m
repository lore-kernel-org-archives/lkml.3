Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3JUCqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:46:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:33688 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752253Ab3JUCqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:46:33 -0400
Message-Id: <20131021024630.330239481@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 20 Oct 2013 22:44:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wang YanQing <udknight@gmail.com>
Subject: [for-next][PATCH 1/6] tracing: Show more exact help information about snapshot
References: <20131021024429.189874455@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Show-more-exact-help-information-about-snaps.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang YanQing <udknight@gmail.com>

The current "help" that comes out of the snapshot file when it is
not allocated looks like this:

 # * Snapshot is freed *
 #
 # Snapshot commands:
 # echo 0 > snapshot : Clears and frees snapshot buffer
 # echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.
 #                      Takes a snapshot of the main buffer.
 # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
 #                      (Doesn't have to be '2' works with any number that
 #                       is not a '0' or '1')

Echo 2 says that it does not allocate the buffer, which is correct,
but to be more consistent with "echo 0" it should also state
that it does not free.

Link: http://lkml.kernel.org/r/20130914045916.GA4243@udknight

Signed-off-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7974ba2..d5f7c4d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2760,7 +2760,7 @@ static void show_snapshot_main_help(struct seq_file *m)
 	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
 	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
 	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
-	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
+	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n");
 	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
 	seq_printf(m, "#                       is not a '0' or '1')\n");
 }
-- 
1.8.4.rc3


