Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336Ab3BLETb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:19:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45761 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3BLETa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:19:30 -0500
Date: Mon, 11 Feb 2013 20:19:18 -0800
From: tip-bot for Mike Travis <travis@sgi.com>
Message-ID: <tip-6edbd4714edd8af64ec6a1bb8d89d0cb2bbe671e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        travis@sgi.com, sivanich@sgi.com, rja@sgi.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        travis@sgi.com, sivanich@sgi.com, rja@sgi.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130211194508.610723192@gulag1.americas.sgi.com>
References: <20130211194508.610723192@gulag1.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv, uv3: Update Hub Info for SGI UV3
Git-Commit-ID: 6edbd4714edd8af64ec6a1bb8d89d0cb2bbe671e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 20:19:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6edbd4714edd8af64ec6a1bb8d89d0cb2bbe671e
Gitweb:     http://git.kernel.org/tip/6edbd4714edd8af64ec6a1bb8d89d0cb2bbe671e
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 11 Feb 2013 13:45:11 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 11 Feb 2013 17:17:50 -0800

x86, uv, uv3: Update Hub Info for SGI UV3

This patch updates the UV HUB info for UV3.  The "is_uv3_hub" and
"is_uvx_hub" (UV2 or UV3) functions are added as well as the addresses
and sizes of the MMR regions for UV3.

Signed-off-by: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/r/20130211194508.610723192@gulag1.americas.sgi.com
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/uv/uv_hub.h | 44 ++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 21f7385..2c32df9 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -5,7 +5,7 @@
  *
  * SGI UV architectural definitions
  *
- * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_HUB_H
@@ -175,6 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
  */
 #define UV1_HUB_REVISION_BASE		1
 #define UV2_HUB_REVISION_BASE		3
+#define UV3_HUB_REVISION_BASE		5
 
 static inline int is_uv1_hub(void)
 {
@@ -183,6 +184,23 @@ static inline int is_uv1_hub(void)
 
 static inline int is_uv2_hub(void)
 {
+	return ((uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE) &&
+		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE));
+}
+
+static inline int is_uv3_hub(void)
+{
+	return uv_hub_info->hub_revision >= UV3_HUB_REVISION_BASE;
+}
+
+static inline int is_uv_hub(void)
+{
+	return uv_hub_info->hub_revision;
+}
+
+/* code common to uv2 and uv3 only */
+static inline int is_uvx_hub(void)
+{
 	return uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE;
 }
 
@@ -230,14 +248,23 @@ union uvh_apicid {
 #define UV2_LOCAL_MMR_SIZE		(32UL * 1024 * 1024)
 #define UV2_GLOBAL_MMR32_SIZE		(32UL * 1024 * 1024)
 
-#define UV_LOCAL_MMR_BASE		(is_uv1_hub() ? UV1_LOCAL_MMR_BASE     \
-						: UV2_LOCAL_MMR_BASE)
-#define UV_GLOBAL_MMR32_BASE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_BASE  \
-						: UV2_GLOBAL_MMR32_BASE)
-#define UV_LOCAL_MMR_SIZE		(is_uv1_hub() ? UV1_LOCAL_MMR_SIZE :   \
-						UV2_LOCAL_MMR_SIZE)
+#define UV3_LOCAL_MMR_BASE		0xfa000000UL
+#define UV3_GLOBAL_MMR32_BASE		0xfc000000UL
+#define UV3_LOCAL_MMR_SIZE		(32UL * 1024 * 1024)
+#define UV3_GLOBAL_MMR32_SIZE		(32UL * 1024 * 1024)
+
+#define UV_LOCAL_MMR_BASE		(is_uv1_hub() ? UV1_LOCAL_MMR_BASE : \
+					(is_uv2_hub() ? UV2_LOCAL_MMR_BASE : \
+							UV3_LOCAL_MMR_BASE))
+#define UV_GLOBAL_MMR32_BASE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_BASE :\
+					(is_uv2_hub() ? UV2_GLOBAL_MMR32_BASE :\
+							UV3_GLOBAL_MMR32_BASE))
+#define UV_LOCAL_MMR_SIZE		(is_uv1_hub() ? UV1_LOCAL_MMR_SIZE : \
+					(is_uv2_hub() ? UV2_LOCAL_MMR_SIZE : \
+							UV3_LOCAL_MMR_SIZE))
 #define UV_GLOBAL_MMR32_SIZE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_SIZE :\
-						UV2_GLOBAL_MMR32_SIZE)
+					(is_uv2_hub() ? UV2_GLOBAL_MMR32_SIZE :\
+							UV3_GLOBAL_MMR32_SIZE))
 #define UV_GLOBAL_MMR64_BASE		(uv_hub_info->global_mmr_base)
 
 #define UV_GLOBAL_GRU_MMR_BASE		0x4000000
@@ -599,6 +626,7 @@ static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
  *     1 - UV1 rev 1.0 initial silicon
  *     2 - UV1 rev 2.0 production silicon
  *     3 - UV2 rev 1.0 initial silicon
+ *     5 - UV3 rev 1.0 initial silicon
  */
 static inline int uv_get_min_hub_revision_id(void)
 {
