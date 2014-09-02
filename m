Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaIBG4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:56:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:51719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaIBG4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:56:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,447,1406617200"; 
   d="scan'208";a="584920162"
Date: Tue, 2 Sep 2014 14:58:36 +0800
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: mina86@mina86.com, balbi@ti.com, mgautam@codeaurora.org,
        andrzej.p@samsung.com
Cc: jin.can.zhuang@intel.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@intel.com,
        hang.yuan@intel.com
Subject: [PATCH] usb: gadget: f_fs: add usb_functionfs_descs_head_v2
Message-ID: <20140902065836.GA23094@intel.com>
Reply-To: jin.can.zhuang@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add usb_functionfs_descs_head_v2 structure for the new layout of
descriptors.

Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
---
 include/uapi/linux/usb/functionfs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 0154b28..0b3f9fc 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -32,6 +32,15 @@ struct usb_endpoint_descriptor_no_audio {
 	__u8  bInterval;
 } __attribute__((packed));
 
+struct usb_functionfs_descs_head_v2 {
+	__le32 magic;
+	__le32 length;
+	__le32 flags;
+	__le32 fs_count;
+	__le32 hs_count;
+	__le32 ss_count;
+} __attribute__((packed));
+
 /* Legacy format, deprecated as of 3.14. */
 struct usb_functionfs_descs_head {
 	__le32 magic;
-- 
1.7.9.5

