Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3ILPE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:04:27 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40087 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3ILPE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:04:26 -0400
Date: Thu, 12 Sep 2013 23:04:01 +0800
From: Wang YanQing <udknight@gmail.com>
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH]trace: fix wrong help information about snapshot
Message-ID: <20130912150401.GA3960@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, rostedt@goodmis.org,
	fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cat snapshot give me:
" tracer: nop

 * Snapshot is freed *

 Snapshot commands:
 echo 0 > snapshot : Clears and frees snapshot buffer
 echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.
                      Takes a snapshot of the main buffer.
 echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
                      (Doesn't have to be '2' works with any number that
                       is not a '0' or '1')"

But after read the code, I found the right information about "echo 2 > snapshot"
should looks like below:

" echo 2 > snapshot : Clears snapshot buffer (but does not free)
                      (Doesn't have to be '2' works with any number that
                       is not a '0' or '1')"

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7974ba2..d0da660 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2760,7 +2760,7 @@ static void show_snapshot_main_help(struct seq_file *m)
 	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
 	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
 	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
-	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
+	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not free)\n");
 	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
 	seq_printf(m, "#                       is not a '0' or '1')\n");
 }
-- 
1.7.12.4.dirty
