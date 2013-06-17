Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3FQOVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:21:08 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39802 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab3FQOVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:21:06 -0400
From: Lorenz Haspel <lorenz@badgers.com>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Lorenz Haspel <lorenz@badgers.com>
Subject: [PATCH 3/5] silicom: checkpatch: explicit initialised statics
Date: Mon, 17 Jun 2013 16:20:15 +0200
Message-Id: <1371478817-28357-3-git-send-email-lorenz@badgers.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
References: <1371478817-28357-1-git-send-email-lorenz@badgers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed checkpatch error:
removed expicit initialisations of statics to 0 or NULL

Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
---
 drivers/staging/silicom/bpctl_mod.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 2420383..78570dd 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -35,7 +35,7 @@
 #define BP_MOD_DESCR "Silicom Bypass-SD Control driver"
 #define BP_SYNC_FLAG 1
 
-static int major_num = 0;
+static int major_num;
 
 MODULE_AUTHOR("Anna Lukin, annal@silicom.co.il");
 MODULE_LICENSE("GPL");
@@ -112,7 +112,7 @@ typedef struct _bpctl_dev {
 static bpctl_dev_t *bpctl_dev_arr;
 
 static struct semaphore bpctl_sema;
-static int device_num = 0;
+static int device_num;
 
 static int get_dev_idx(int ifindex);
 static bpctl_dev_t *get_master_port_fn(bpctl_dev_t *pbpctl_dev);
@@ -134,7 +134,7 @@ static int bp_device_event(struct notifier_block *unused,
 			   unsigned long event, void *ptr)
 {
 	struct net_device *dev = ptr;
-	static bpctl_dev_t *pbpctl_dev = NULL, *pbpctl_dev_m = NULL;
+	static bpctl_dev_t *pbpctl_dev, *pbpctl_dev_m;
 	int dev_num = 0, ret = 0, ret_d = 0, time_left = 0;
 	/* printk("BP_PROC_SUPPORT event =%d %s %d\n", event,dev->name, dev->ifindex ); */
 	/* return NOTIFY_DONE; */
@@ -7855,7 +7855,7 @@ RW_FOPS(wd_autoreset)
 int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block)
 {
 	struct bypass_pfs_sd *current_pfs = &(pbp_device_block->bypass_pfs_set);
-	static struct proc_dir_entry *procfs_dir = NULL;
+	static struct proc_dir_entry *procfs_dir;
 	int ret = 0;
 
 	if (!pbp_device_block->ndev)
-- 
1.7.10.4

