Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaFMNpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:45:25 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:54874 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaFMNpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:45:24 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>, <stable@vger.kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv4 1/6] usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
Date: Fri, 13 Jun 2014 15:38:04 +0200
Message-Id: <1402666689-4971-2-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402666689-4971-1-git-send-email-mina86@mina86.com>
References: <1402666689-4971-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though usb_functionfs_descs_head structure is now deprecated,
it has been used by some user space tools.  Its removel in commit
[ac8dde1: “Add flags to descriptors block”] was an oversight
leading to build breakage for such tools.

Bring it back so that old user space tools can still be build
without problems on newer kernel versions.

Cc: <stable@vger.kernel.org>  # 3.14
Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Reported-by: Krzysztof Opasiak <k.opasiak@samsung.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/uapi/linux/usb/functionfs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 2a4b4a7..24b68c5 100644
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
+} __attribute__((packed, deprecated));
 
 /*
  * Descriptors format:
-- 
2.0.0.526.g5318336

