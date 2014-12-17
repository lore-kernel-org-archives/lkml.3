Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaLQRey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:34:54 -0500
Received: from mail-pd0-f193.google.com ([209.85.192.193]:35944 "EHLO pdir10"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751108AbaLQRev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:34:51 -0500
From: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hariharan Rangasamy <hariharanrangasamy@gmail.com>
Subject: [PATCH] Staging : lustre : replaced seq_printf() with seq_puts and changed include statement
Date: Wed, 17 Dec 2014 23:04:41 +0530
Message-Id: <1418837681-7555-1-git-send-email-hariharanrangasamy@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used seq_puts instead of seq_printf()
Used #include <linux/statfs.h> instead of #include <asm/statfs.h>

Signed-off-by: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 9f719bc..d64a400 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -35,7 +35,7 @@
  */
 #define DEBUG_SUBSYSTEM S_CLASS
 
-#include <asm/statfs.h>
+#include <linux/statfs.h>
 #include "../include/obd_cksum.h"
 #include "../include/obd_class.h"
 #include "../include/lprocfs_status.h"
@@ -358,7 +358,7 @@ static int osc_checksum_type_seq_show(struct seq_file *m, void *v)
 		else
 			seq_printf(m, "%s ", cksum_name[i]);
 	}
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 	return 0;
 }
 
@@ -590,7 +590,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "pending read pages:   %d\n",
 		   atomic_read(&cli->cl_pending_r_pages));
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "pages per rpc	 rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
@@ -613,7 +613,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "rpcs in flight	rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
@@ -636,7 +636,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
 	seq_printf(seq, "offset		rpcs   %% cum %% |");
 	seq_printf(seq, "       rpcs   %% cum %%\n");
 
-- 
1.9.1

