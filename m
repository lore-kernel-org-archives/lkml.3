Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaLQT2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:28:07 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44857 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaLQT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:28:03 -0500
Message-ID: <1418844479.9555.2.camel@hari-laptop>
Subject: [PATCH 2/2] Staging: lustre: lproc_osc.c: used seq_puts() and
 seq_putc() instead of seq_printf()
From: Hariharan <rhariharan.cbe@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 00:57:59 +0530
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 55d1ae4a440126e5befa9de4698a7aac57319885 Mon Sep 17 00:00:00 2001
From: Hariharan Rangasamy <rhariharan.cbe@gmail.com>
Date: Thu, 18 Dec 2014 00:04:24 +0530
Subject: [PATCH 2/2] Staging: lustre: lproc_osc.c: used seq_puts() and
 seq_putc() instead of seq_printf()

used seq_puts() and seq_putc() instead of seq_printf().

Signed-off-by: Hariharan Rangasamy <rhariharan.cbe@gmail.com>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c
b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index f578b51..7cd9638 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -358,7 +358,7 @@ static int osc_checksum_type_seq_show(struct
seq_file *m, void *v)
 		else
 			seq_printf(m, "%s ", cksum_name[i]);
 	}
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 	return 0;
 }
 
@@ -590,9 +590,9 @@ static int osc_rpc_stats_seq_show(struct seq_file
*seq, void *v)
 	seq_printf(seq, "pending read pages:   %d\n",
 		   atomic_read(&cli->cl_pending_r_pages));
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
-	seq_printf(seq, "pages per rpc	 rpcs   %% cum %% |");
-	seq_printf(seq, "       rpcs   %% cum %%\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "pages per rpc	 rpcs   % cum % |");
+	seq_puts(seq, "       rpcs   % cum %\n");
 
 	read_tot = lprocfs_oh_sum(&cli->cl_read_page_hist);
 	write_tot = lprocfs_oh_sum(&cli->cl_write_page_hist);
@@ -613,9 +613,9 @@ static int osc_rpc_stats_seq_show(struct seq_file
*seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
-	seq_printf(seq, "rpcs in flight	rpcs   %% cum %% |");
-	seq_printf(seq, "       rpcs   %% cum %%\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "rpcs in flight	rpcs   % cum % |");
+	seq_puts(seq, "       rpcs   % cum %\n");
 
 	read_tot = lprocfs_oh_sum(&cli->cl_read_rpc_hist);
 	write_tot = lprocfs_oh_sum(&cli->cl_write_rpc_hist);
@@ -636,9 +636,9 @@ static int osc_rpc_stats_seq_show(struct seq_file
*seq, void *v)
 			break;
 	}
 
-	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
-	seq_printf(seq, "offset		rpcs   %% cum %% |");
-	seq_printf(seq, "       rpcs   %% cum %%\n");
+	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
+	seq_puts(seq, "offset		rpcs   % cum % |");
+	seq_puts(seq, "       rpcs   % cum %\n");
 
 	read_tot = lprocfs_oh_sum(&cli->cl_read_offset_hist);
 	write_tot = lprocfs_oh_sum(&cli->cl_write_offset_hist);
-- 
1.9.1



