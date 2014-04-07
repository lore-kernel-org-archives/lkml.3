Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaDGDDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 23:03:48 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37563 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaDGDDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 23:03:47 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: chad@dahc.us, viro@zeniv.linux.org.uk, tulinizer@gmail.com,
        lorenz@badgers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: silicom: Add appropriate ifdef conditions in bpctl_mod.c
Date: Mon, 07 Apr 2014 12:03:41 +0900
Message-ID: <5315479.ef9aFRk9hG@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The bp_proc_create() can be called if BP_PROC_SUPPORT is defined.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/silicom/bpctl_mod.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 6b9365b..5a3d758 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -119,7 +119,10 @@ static void if_scan_init(void);
 
 static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
 static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
+
+#ifdef BP_PROC_SUPPORT
 static int bp_proc_create(void);
+#endif
 
 static int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
 static int get_dev_idx_bsf(int bus, int slot, int func);
@@ -6783,6 +6786,7 @@ EXPORT_SYMBOL(bp_if_scan_sd);
 
 static struct proc_dir_entry *bp_procfs_dir;
 
+#ifdef BP_PROC_SUPPORT
 static int bp_proc_create(void)
 {
 	bp_procfs_dir = proc_mkdir(BP_PROC_DIR, init_net.proc_net);
@@ -6794,6 +6798,7 @@ static int bp_proc_create(void)
 	}
 	return 0;
 }
+#endif
 
 static int procfs_add(char *proc_name, const struct file_operations *fops,
 		      struct bpctl_dev *dev)
-- 
1.7.4.4


