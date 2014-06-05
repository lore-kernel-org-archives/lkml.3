Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaFEHt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:49:58 -0400
Received: from mail-la0-f73.google.com ([209.85.215.73]:54116 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFEHtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:49:55 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 03:49:54 EDT
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Krzysztof Opasiak <k.opasiak@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, <stable@vger.kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 1/2] usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
Date: Thu,  5 Jun 2014 09:43:25 +0200
Message-Id: <1401954206-8491-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though usb_functionfs_descs_head structure is now deprecated,
it has been used by some user space tools.  It's removel in commit
[ac8dde1: Add flags to descriptors block] was an oversight leading
to build breakage for such tools.

Bring it back so that old user space tools can still be build
without problems on newer kernel versions.

Cc: <stable@vger.kernel.org>  # 3.14
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/uapi/linux/usb/functionfs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 2a4b4a7..92c94e8 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -33,6 +33,13 @@ struct usb_endpoint_descriptor_no_audio {
 	__u8  bInterval;
 } __attribute__((packed));
 
+/* Legacy format, deprecated as of 3.14. */
+struct usb_functionfs_descs_head {
+	__le32 magic;
+	__le32 length;
+	__le32 fs_count;
+	__le32 hs_count;
+} __attribute__((packed));
 
 /*
  * Descriptors format:
-- 
2.0.0.526.g5318336

