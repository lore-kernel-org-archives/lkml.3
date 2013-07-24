Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3GXUzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:55:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52757 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3GXUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:54:40 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 9/9] ARM: msm: Only compile io.c on platforms that use it
Date: Wed, 24 Jul 2013 13:54:34 -0700
Message-Id: <1374699274-18388-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
In-Reply-To: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
References: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only the non-dt based MSM platforms need to map memory from their
machine descriptor. Unfortunately it is always compiled if
ARCH_MSM=y and the file also has mach/ includes in it. Since
dt-based MSM platforms aren't actually using anything in this
file just compile io.c on the non-dt based MSM platforms. This
allows the dt-based platforms to participate in the
multi-platform kernel.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 4c248ba..d872634c 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,4 +1,4 @@
-obj-y += io.o timer.o
+obj-y += timer.o
 obj-y += clock.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
@@ -8,9 +8,9 @@ obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
 
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
 
-obj-$(CONFIG_ARCH_MSM7X00A) += dma.o
-obj-$(CONFIG_ARCH_MSM7X30) += dma.o
-obj-$(CONFIG_ARCH_QSD8X50) += dma.o
+obj-$(CONFIG_ARCH_MSM7X00A) += dma.o io.o
+obj-$(CONFIG_ARCH_MSM7X30) += dma.o io.o
+obj-$(CONFIG_ARCH_QSD8X50) += dma.o io.o
 
 obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

