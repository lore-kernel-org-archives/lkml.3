Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3KDRI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:08:29 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:58182 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3KDRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:25 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 4/9] GenWQE: Rework comments
Date: Mon,  4 Nov 2013 18:08:04 +0100
Message-Id: <1383584889-21594-5-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-8372-0000-0000-000007A9DB68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some leftovers from the comment cleanup. Fix them up such that
they match the requested format.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 include/linux/genwqe/genwqe_card.h |   40 +++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/include/linux/genwqe/genwqe_card.h b/include/linux/genwqe/genwqe_card.h
index aa3f1b9..5a75147 100644
--- a/include/linux/genwqe/genwqe_card.h
+++ b/include/linux/genwqe/genwqe_card.h
@@ -383,7 +383,7 @@ struct chip_bitstream {
 	uint32_t progress;		/* progress code from processing  */
 };
 
-/* issuing a specific DDCB command */
+/* Issuing a specific DDCB command */
 #define DDCB_LENGTH			256 /* for debug data */
 #define DDCB_ASIV_LENGTH		104 /* len of the DDCB ASIV array */
 #define DDCB_ASIV_LENGTH_ATS		96  /* ASIV in ATS architecture */
@@ -427,10 +427,12 @@ struct genwqe_debug_data {
 #define ATS_GET_FLAGS(_ats, _byte_offs)					\
 	(((_ats)	  >> (44 - (4 * ((_byte_offs) / 8)))) & 0xf)
 
-/*
- * User parameter for generic DDCB commands. On the way into the
- * kernel the driver will read the whole data structure. On the way
- * out the driver will not copy the ASIV data back to userland.
+/**
+ * struct genwqe_ddcb_cmd - User parameter for generic DDCB commands
+ *
+ * On the way into the kernel the driver will read the whole data
+ * structure. On the way out the driver will not copy the ASIV data
+ * back to user-space.
  */
 struct genwqe_ddcb_cmd {
 	/* ------ START of data copied to/from driver ---------------------- */
@@ -495,7 +497,12 @@ static inline void genwqe_ddcb_cmd_init(struct genwqe_ddcb_cmd *cmd)
 #define GENWQE_GET_CARD_STATE _IOR(GENWQE_IOC_CODE, 36,		\
 				   enum genwqe_card_state *)
 
-/*
+/**
+ * struct genwqe_mem - Memory pinning/unpinning information
+ * @addr:          virtual user space address
+ * @size:          size of the area pin/dma-map/unmap
+ * direction:      0: read/1: read and write
+ *
  * Avoid pinning and unpinning of memory pages dynamically. Instead
  * the idea is to pin the whole buffer space required for DDCB
  * opertionas in advance. The driver will reuse this pinning and the
@@ -509,26 +516,23 @@ static inline void genwqe_ddcb_cmd_init(struct genwqe_ddcb_cmd *cmd)
  * memory.
  */
 struct genwqe_mem {
-	unsigned long addr;	/* virtual user space address */
-	unsigned long size;	/* size of the area pin/dma-map/unmap */
-	int direction;		/* 0: read/1: read and write */
+	unsigned long addr;
+	unsigned long size;
+	int direction;
 };
 
 #define GENWQE_PIN_MEM	      _IOWR(GENWQE_IOC_CODE, 40, struct genwqe_mem *)
 #define GENWQE_UNPIN_MEM      _IOWR(GENWQE_IOC_CODE, 41, struct genwqe_mem *)
 
 /*
- * @brief Generic synchronous DDCB execution interface.
+ * Generic synchronous DDCB execution interface.
  * Synchronously execute a DDCB.
  *
- * @param [in] fd        open file descriptor to the genwqe_card device.
- * @param [inout] cmd    DDCB execution request
- * @return               0 on success or negative error code.
- *              -EINVAL: Invalid parameters (ASIV_LEN, ASV_LEN, illegal fixups
- *                       no mappings found/could not create mappings.
- *              -EFAULT: illegal addresses in fixups.
- *                       purging failed.
- *             -EBADMSG: enqueing failed, retc != DDCB_RETC_COMPLETE.
+ * Return: 0 on success or negative error code.
+ *         -EINVAL: Invalid parameters (ASIV_LEN, ASV_LEN, illegal fixups
+ *                  no mappings found/could not create mappings
+ *         -EFAULT: illegal addresses in fixups, purging failed
+ *         -EBADMSG: enqueing failed, retc != DDCB_RETC_COMPLETE
  */
 #define GENWQE_EXECUTE_DDCB					\
 	_IOWR(GENWQE_IOC_CODE, 50, struct genwqe_ddcb_cmd *)
-- 
1.7.1

