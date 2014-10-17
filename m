Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaJQPKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJQPKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:10:11 -0400
From: WANG Chao <chaowang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH] iscsi_ibft: convert printk() to pr_foo()
Date: Fri, 17 Oct 2014 23:09:59 +0800
Message-Id: <1413558599-15120-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to pr_foo() and a common prefix ("iscsi_ibft: ") to each printk
message it generates. The printk message used to break down into multiple
lines, now squash these into a single string.

Along with this patch, use multiple MODULE_AUTHOR() marco as
recommended.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 drivers/firmware/iscsi_ibft.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 071c2c9..5f9b307 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -67,6 +67,8 @@
  */
 
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/capability.h>
 #include <linux/ctype.h>
@@ -87,8 +89,8 @@
 #define IBFT_ISCSI_VERSION "0.5.0"
 #define IBFT_ISCSI_DATE "2010-Feb-25"
 
-MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and "
-	      "Konrad Rzeszutek <ketuzsezr@darnok.org>");
+MODULE_AUTHOR("Peter Jones <pjones@redhat.com>");
+MODULE_AUTHOR("Konrad Rzeszutek <ketuzsezr@darnok.org>");
 MODULE_DESCRIPTION("sysfs interface to BIOS iBFT information");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IBFT_ISCSI_VERSION);
@@ -223,15 +225,13 @@ static ssize_t sprintf_string(char *str, int len, char *buf)
 static int ibft_verify_hdr(char *t, struct ibft_hdr *hdr, int id, int length)
 {
 	if (hdr->id != id) {
-		printk(KERN_ERR "iBFT error: We expected the %s " \
-				"field header.id to have %d but " \
-				"found %d instead!\n", t, id, hdr->id);
+		pr_err("iBFT error: We expected the %s field header.id to have %d but found %d instead!\n",
+				t, id, hdr->id);
 		return -ENODEV;
 	}
 	if (hdr->length != length) {
-		printk(KERN_ERR "iBFT error: We expected the %s " \
-				"field header.length to have %d but " \
-				"found %d instead!\n", t, length, hdr->length);
+		pr_err("iBFT error: We expected the %s field header.length to have %d but found %d instead!\n",
+				t, length, hdr->length);
 		return -ENODEV;
 	}
 
@@ -413,8 +413,7 @@ static int __init ibft_check_device(void)
 
 	/* Sanity checking of iBFT. */
 	if (ibft_addr->header.revision != 1) {
-		printk(KERN_ERR "iBFT module supports only revision 1, " \
-				"while this is %d.\n",
+		pr_err("iBFT module supports only revision 1, while this is %d.\n",
 				ibft_addr->header.revision);
 		return -ENOENT;
 	}
@@ -422,7 +421,7 @@ static int __init ibft_check_device(void)
 		csum += *pos;
 
 	if (csum) {
-		printk(KERN_ERR "iBFT has incorrect checksum (0x%x)!\n", csum);
+		pr_err("iBFT has incorrect checksum (0x%x)!\n", csum);
 		return -ENOENT;
 	}
 
@@ -646,9 +645,8 @@ static int __init ibft_create_kobject(struct acpi_table_ibft *header,
 		rc = 1;
 		break;
 	default:
-		printk(KERN_ERR "iBFT has unknown structure type (%d). " \
-				"Report this bug to %.6s!\n", hdr->id,
-				header->header.oem_id);
+		pr_err("iBFT has unknown structure type (%d). Report this bug to %.6s!\n",
+				hdr->id, header->header.oem_id);
 		rc = 1;
 		break;
 	}
@@ -703,7 +701,7 @@ static int __init ibft_register_kobjects(struct acpi_table_ibft *header)
 	/* iBFT table safety checking */
 	rc |= ((control->hdr.index) ? -ENODEV : 0);
 	if (rc) {
-		printk(KERN_ERR "iBFT error: Control header is invalid!\n");
+		pr_err("iBFT error: Control header is invalid!\n");
 		return rc;
 	}
 	for (ptr = &control->initiator_off; ptr < end; ptr += sizeof(u16)) {
@@ -809,7 +807,7 @@ static int __init ibft_init(void)
 		if (rc)
 			goto out_free;
 	} else
-		printk(KERN_INFO "No iBFT detected.\n");
+		pr_info("No iBFT detected.\n");
 
 	return 0;
 
-- 
1.9.3

