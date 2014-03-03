Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaCCQwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:52:31 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaCCQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:52:30 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/2] spmi: pmic_arb: make selectable on ARCH_QCOM
Date: Mon,  3 Mar 2014 10:49:43 -0600
Message-Id: <1393865384-28145-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the split of Qualcomm MSM support into legacy and multiplatform,
the SPMI PMIC arb driver is only relevant on the multiplatform supported
SoCs. Switch the Kconfig depends to ARCH_QCOM.

Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/spmi/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
index 075bd79..bf1295e 100644
--- a/drivers/spmi/Kconfig
+++ b/drivers/spmi/Kconfig
@@ -14,8 +14,8 @@ config SPMI_MSM_PMIC_ARB
 	tristate "Qualcomm MSM SPMI Controller (PMIC Arbiter)"
 	depends on ARM
 	depends on IRQ_DOMAIN
-	depends on ARCH_MSM || COMPILE_TEST
-	default ARCH_MSM
+	depends on ARCH_QCOM || COMPILE_TEST
+	default ARCH_QCOM
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in SPMI PMIC Arbiter interface on Qualcomm MSM family
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

