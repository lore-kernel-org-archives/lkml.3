Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3GXUym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:54:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52742 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3GXUyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:54:37 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/9] ARM: msm: Don't compile __msm_ioremap_caller() unless used
Date: Wed, 24 Jul 2013 13:54:27 -0700
Message-Id: <1374699274-18388-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
References: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only used on MSM7x00A so only compile the
function if the build includes support for that platform.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 3dc04cc..4a1a222 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -168,6 +168,7 @@ void __init msm_map_msm7x30_io(void)
 }
 #endif /* CONFIG_ARCH_MSM7X30 */
 
+#ifdef CONFIG_ARCH_MSM7X00A
 void __iomem *__msm_ioremap_caller(phys_addr_t phys_addr, size_t size,
 				   unsigned int mtype, void *caller)
 {
@@ -182,3 +183,4 @@ void __iomem *__msm_ioremap_caller(phys_addr_t phys_addr, size_t size,
 
 	return __arm_ioremap_caller(phys_addr, size, mtype, caller);
 }
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

