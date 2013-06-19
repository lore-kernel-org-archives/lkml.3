Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab3FSAFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:05:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35510 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829Ab3FSAEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:49 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/11] ARM: msm: Only compile io.c on platforms that use it
Date: Tue, 18 Jun 2013 17:04:39 -0700
Message-Id: <1371600281-6118-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
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

