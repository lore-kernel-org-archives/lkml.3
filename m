Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaEBQ2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:28:52 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:52433 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaEBQ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:28:45 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Cc: devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] staging/lustre/libcfs: Fix build errors for !CONFIG_SMP
Date: Fri,  2 May 2014 18:28:33 +0200
Message-Id: <1399048115-19506-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_SMP=n:

drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h:58:31: fatal error: libcfs/libcfs_cpu.h: No such file or directory

drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c:78:1: error: redefinition of 'cfs_cpt_table_print'
drivers/staging/lustre/include/linux/libcfs/libcfs_cpu.h:109:1: note: previous definition of 'cfs_cpt_table_print' was here

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/11054360/
---
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |    2 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
index 72c76ad96ce9..ccee5c3e4142 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
@@ -55,7 +55,7 @@
 
 #ifndef HAVE_LIBCFS_CPT
 /* Need this for cfs_cpt_table */
-#include <libcfs/libcfs_cpu.h>
+#include <linux/libcfs/libcfs_cpu.h>
 #endif
 
 #define CFS_PAGE_MASK		   (~((__u64)PAGE_CACHE_SIZE-1))
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c b/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
index d985e83ba2c3..a1a7bf44cccf 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
@@ -74,6 +74,7 @@ cfs_cpt_table_free(struct cfs_cpt_table *cptab)
 }
 EXPORT_SYMBOL(cfs_cpt_table_free);
 
+#ifdef CONFIG_SMP
 int
 cfs_cpt_table_print(struct cfs_cpt_table *cptab, char *buf, int len)
 {
@@ -87,6 +88,7 @@ cfs_cpt_table_print(struct cfs_cpt_table *cptab, char *buf, int len)
 	return rc;
 }
 EXPORT_SYMBOL(cfs_cpt_table_print);
+#endif /* CONFIG_SMP */
 
 int
 cfs_cpt_number(struct cfs_cpt_table *cptab)
-- 
1.7.9.5

