Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaJXAfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:35:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53594 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbaJXAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:35:10 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] soc: qcom: scm: Clarify boot interface
Date: Thu, 23 Oct 2014 17:35:07 -0700
Message-Id: <1414110907-17977-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The secure world only knows about 32-bit wide physical addresses
for the boot API. Clarify the kernel interface by explicitly
stating a u32 instead of phys_addr_t which could be 32 or 64 bits
depending on LPAE or not.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/soc/qcom/scm-boot.c | 2 +-
 include/soc/qcom/scm-boot.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/scm-boot.c b/drivers/soc/qcom/scm-boot.c
index 3e4d77b371c6..af16fcc8d5cb 100644
--- a/drivers/soc/qcom/scm-boot.c
+++ b/drivers/soc/qcom/scm-boot.c
@@ -24,7 +24,7 @@
 /*
  * Set the cold/warm boot address for one of the CPU cores.
  */
-int scm_set_boot_addr(phys_addr_t addr, int flags)
+int scm_set_boot_addr(u32 addr, int flags)
 {
 	struct {
 		__le32 flags;
diff --git a/include/soc/qcom/scm-boot.h b/include/soc/qcom/scm-boot.h
index 02b445c426ce..3e210fb818bb 100644
--- a/include/soc/qcom/scm-boot.h
+++ b/include/soc/qcom/scm-boot.h
@@ -21,6 +21,6 @@
 #define SCM_FLAG_WARMBOOT_CPU2		0x10
 #define SCM_FLAG_WARMBOOT_CPU3		0x40
 
-int scm_set_boot_addr(phys_addr_t addr, int flags);
+int scm_set_boot_addr(u32 addr, int flags);
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

