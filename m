Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaFFJNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:13:25 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35143 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaFFJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:13:00 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 3/5] usb: gadget: f_fs: add usb_functionfs_descs_head_v2 structure
Date: Fri,  6 Jun 2014 11:12:54 +0200
Message-Id: <1402045976-26580-3-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402045976-26580-1-git-send-email-mina86@mina86.com>
References: <1402045976-26580-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The structure can be used with user space tools that use the new
functionfs description format, for example as follows:

static const struct {
	struct usb_functionfs_descs_head_v2 header;
	__le32 fs_count;
	__le32 hs_count;
	struct {
		…
	} fs_desc;
	struct {
		…
	} hs_desc;
} descriptors = {
	.header = {
		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC_V2),
		.length = cpu_to_le32(sizeof(descriptors)),
		.flags = cpu_to_le32(FUNCTIONFS_HAS_FS_DESC |
				     FUNCTIONFS_HAS_HS_DESC)
	},
	.fs_count = cpu_to_le32(X),
	.fs_desc = {
		…
	},
	.hs_count = cpu_to_le32(Y),
	.hs_desc = {
		…
	}
};

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/uapi/linux/usb/functionfs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 24b68c5..2592d86 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -33,6 +33,16 @@ struct usb_endpoint_descriptor_no_audio {
 	__u8  bInterval;
 } __attribute__((packed));
 
+struct usb_functionfs_descs_head_v2 {
+	__le32 magic;
+	__le32 length;
+	__le32 flags;
+	/*
+	 * __le32 fs_count, hs_count, fs_count; must be included manually in
+	 * the structure taking flags into consideration.
+	 */
+} __attribute__((packed));
+
 /* Legacy format, deprecated as of 3.14. */
 struct usb_functionfs_descs_head {
 	__le32 magic;
-- 
2.0.0.526.g5318336

