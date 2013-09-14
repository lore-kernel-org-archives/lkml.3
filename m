Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3INE7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:59:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34926 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3INE7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:59:38 -0400
Date: Sat, 14 Sep 2013 12:59:16 +0800
From: Wang YanQing <udknight@gmail.com>
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] trace: show more and exactly help information about
 snapshot
Message-ID: <20130914045916.GA4243@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, rostedt@goodmis.org,
	fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, they both are correct:

	default:
		if (tr->allocated_snapshot) {
			if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
				tracing_reset_online_cpus(&tr->max_buffer);
			else
				tracing_reset(&tr->max_buffer,	iter->cpu_file);
		}
		break;
	}

It does nothing if it isn't allocated.

Perhaps we need it to say "(but does not allocate or free)"

-- Steve

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 I think "Clears and frees" are reasonable, and
 "Clears and allocates are not so reasonable, so
 we don't need to say not allocate. But it is help 
 information, so make it more clearer is also acceptable. :)
 
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
1.7.12.4.dirty
