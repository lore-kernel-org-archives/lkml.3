Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbaELPOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:14:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:21054 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758556AbaELPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:06 -0400
Message-Id: <20140512151203.728694991@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 07/13] ftrace: Write in missing comment from a very old commit
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-ftrace-Write-in-missing-comment-from-a-very-old-comm.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Back in 2011 Commit ed926f9b35cda "ftrace: Use counters to enable
functions to trace" changed the way ftrace accounts for enabled
and disabled traced functions. There was a comment started as:

	/*
	 *
	 */

But never finished. Well, that's rather useless. I probably forgot
to save the file before committing it. And it passed review from all
this time.

Anyway, better late than never. I updated the comment to express what
is happening in that somewhat complex code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2c99d1f..61f39f8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1552,7 +1552,14 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			in_other_hash = !!ftrace_lookup_ip(other_hash, rec->ip);
 
 			/*
+			 * If filter_hash is set, we want to match all functions
+			 * that are in the hash but not in the other hash.
 			 *
+			 * If filter_hash is not set, then we are decrementing.
+			 * That means we match anything that is in the hash
+			 * and also in the other_hash. That is, we need to turn
+			 * off functions in the other hash because they are disabled
+			 * by this hash.
 			 */
 			if (filter_hash && in_hash && !in_other_hash)
 				match = 1;
-- 
1.8.5.3


