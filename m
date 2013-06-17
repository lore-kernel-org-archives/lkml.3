Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3FQQ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:27:05 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40811 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab3FQQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:26:42 -0400
From: Lorenz Haspel <lorenz@badgers.com>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Lorenz Haspel <lorenz@badgers.com>
Subject: [PATCH 4/4] solicom: checkpatch: added parenthesis to macros
Date: Mon, 17 Jun 2013 18:26:26 +0200
Message-Id: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed checkpatch error:
added parenthesis around complex macros.

Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
---
 drivers/staging/silicom/bpctl_mod.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index b1d6041..c08aa9f 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -44,9 +44,11 @@ MODULE_VERSION(BP_MOD_VER);
 spinlock_t bpvm_lock;
 
 #define lock_bpctl()					\
-if (down_interruptible(&bpctl_sema)) {			\
-	return -ERESTARTSYS;				\
-}							\
+do {							\
+	if (down_interruptible(&bpctl_sema)) {		\
+		return -ERESTARTSYS;			\
+	}						\
+} while (0)
 
 #define unlock_bpctl()					\
 	up(&bpctl_sema);
@@ -7879,7 +7881,8 @@ int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block)
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

