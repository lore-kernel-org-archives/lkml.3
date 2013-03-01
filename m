Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3CAF1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:27:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3CAF1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:27:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,759,1355068800"; 
   d="scan'208";a="6791823"
From: liguang <lig.fnst@cn.fujitsu.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] x86: add e820 descriptor attribute field
Date: Fri, 1 Mar 2013 13:27:18 +0800
Message-Id: <1362115638-10583-2-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1362115638-10583-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1362115638-10583-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 13:26:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 13:26:50,
	Serialize complete at 2013/03/01 13:26:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to ACPI 5.0 Table 15-273
Address Range Descriptor Structure,
offset 20 is 32-bit field of Extended
Attributes for Address Range Descriptor Structure.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 arch/x86/include/uapi/asm/e820.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index 2d400b1..eb87284 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -38,6 +38,10 @@
 #define E820_TYPE_NVS	4
 #define E820_TYPE_UNUSABLE	5
 
+#define E820_ATTRIB_NV 0x2
+#define E820_ATTRIB_SLOW_ACCESS 0x4
+#define E820_ATTRIB_ERR_LOG 0x8
+
 
 /*
  * reserved RAM used by kernel itself
@@ -53,7 +57,8 @@ struct e820entry {
 	__u64 addr;	/* start of memory segment */
 	__u64 size;	/* size of memory segment */
 	__u32 type;	/* type of memory segment */
-} __attribute__((packed));
+	__u32 attrib;
+};
 
 struct e820map {
 	__u32 nr_map;
-- 
1.7.2.5

