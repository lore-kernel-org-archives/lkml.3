Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3FQTUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:20:55 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45305 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab3FQTUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:20:53 -0400
From: Lorenz Haspel <lorenz@badgers.com>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de, lorenz@badgers.com
Subject: [PATCH 4/4 v2] silicom: checkpatch: errors caused by macros
Date: Mon, 17 Jun 2013 21:20:14 +0200
Message-Id: <1371496814-26104-1-git-send-email-lorenz@badgers.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
References: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed checkpatch error:
added parenthesis around complex macro.

Macro with return was only used once in the code,
so I expandet it in-place.

Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
---
v2: expanded macro in-place
---
 drivers/staging/silicom/bpctl_mod.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 5511f5e..d2b8004 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -43,11 +43,6 @@ MODULE_DESCRIPTION(BP_MOD_DESCR);
 MODULE_VERSION(BP_MOD_VER);
 spinlock_t bpvm_lock;
 
-#define lock_bpctl()					\
-if (down_interruptible(&bpctl_sema)) {			\
-	return -ERESTARTSYS;				\
-}							\
-
 #define unlock_bpctl()					\
 	up(&bpctl_sema);
 
@@ -5452,7 +5447,8 @@ static long device_ioctl(struct file *file,	/* see include/linux/fs.h */
 	static bpctl_dev_t *pbpctl_dev;
 
 	/* lock_kernel(); */
-	lock_bpctl();
+	if (down_interruptible(&bpctl_sema))
+		return -ERESTARTSYS;
 	/* local_irq_save(flags); */
 	/* if(!spin_trylock_irqsave(&bpvm_lock)){
 	   local_irq_restore(flags);
@@ -7911,7 +7907,8 @@ int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block)
 	}
 	current_pfs->bypass_entry = procfs_dir;
 
-#define ENTRY(x) ret |= procfs_add(#x, &x##_ops, pbp_device_block)
+#define ENTRY(x) (ret |= procfs_add(#x, &x##_ops, pbp_device_block))
+
 	ENTRY(bypass_info);
 	if (pbp_device_block->bp_caps & SW_CTL_CAP) {
 		/* Create set param proc's */
-- 
1.7.10.4

