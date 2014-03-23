Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaCWMNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 08:13:25 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34937 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaCWMNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 08:13:23 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: [PATCH] staging: cxt1e1: hwprobe: fix incorrect type in assignment
Date: Sun, 23 Mar 2014 14:13:16 +0200
Message-Id: <1395576796-17896-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes "incorrect type in argument 1" warning from sparse.

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/staging/cxt1e1/hwprobe.c       |    6 +++---
 drivers/staging/cxt1e1/pmcc4_private.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 9b4198b..1a145ea 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -174,12 +174,12 @@ cleanup_ioremap(void)
 		if (hi->pci_slot == 0xff)
 			break;
 		if (hi->addr_mapped[0]) {
-			iounmap((void *)(hi->addr_mapped[0]));
+			iounmap(hi->addr_mapped[0]);
 			release_mem_region((long) hi->addr[0], hi->len[0]);
 			hi->addr_mapped[0] = 0;
 		}
 		if (hi->addr_mapped[1]) {
-			iounmap((void *)(hi->addr_mapped[1]));
+			iounmap(hi->addr_mapped[1]);
 			release_mem_region((long) hi->addr[1], hi->len[1]);
 			hi->addr_mapped[1] = 0;
 		}
@@ -329,7 +329,7 @@ c4hw_attach_all(void)
 				return -ENOMEM;
 			}
 
-			hi->addr_mapped[j] = (unsigned long)ioremap(hi->addr[j], hi->len[j]);
+			hi->addr_mapped[j] = ioremap(hi->addr[j], hi->len[j]);
 			if (!hi->addr_mapped[j]) {
 				pr_warning("%s: ioremap fails, addr=0x%lx, len=0x%lx ?\n",
 					   hi->devname, hi->addr[j], hi->len[j]);
diff --git a/drivers/staging/cxt1e1/pmcc4_private.h b/drivers/staging/cxt1e1/pmcc4_private.h
index eb28f09..451f12f 100644
--- a/drivers/staging/cxt1e1/pmcc4_private.h
+++ b/drivers/staging/cxt1e1/pmcc4_private.h
@@ -262,7 +262,7 @@ struct s_hdw_info
     struct pci_dev *pdev[2];
 
     unsigned long addr[2];
-    unsigned long addr_mapped[2];
+    void __iomem *addr_mapped[2];
     unsigned long len[2];
 
     union
-- 
1.7.9.5

