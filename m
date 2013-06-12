Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3FLBse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:48:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59579 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab3FLBsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:48:09 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] ARM: msm: Don't compile __msm_ioremap_caller() unless used
Date: Tue, 11 Jun 2013 18:48:06 -0700
Message-Id: <1371001686-15985-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.251.g1462b67
In-Reply-To: <1371001686-15985-1-git-send-email-sboyd@codeaurora.org>
References: <1371001686-15985-1-git-send-email-sboyd@codeaurora.org>
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
index cc077c5..f16a6bf 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -129,6 +129,7 @@ void __init msm_map_msm7x30_io(void)
 }
 #endif /* CONFIG_ARCH_MSM7X30 */
 
+#ifdef CONFIG_ARCH_MSM7X00A
 void __iomem *__msm_ioremap_caller(unsigned long phys_addr, size_t size,
 				   unsigned int mtype, void *caller)
 {
@@ -143,3 +144,4 @@ void __iomem *__msm_ioremap_caller(unsigned long phys_addr, size_t size,
 
 	return __arm_ioremap_caller(phys_addr, size, mtype, caller);
 }
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

