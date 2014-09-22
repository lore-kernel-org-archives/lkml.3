Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaIVVmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:42:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36959 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaIVVmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:42:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: qcom: Select ARCH_SUPPORTS_BIG_ENDIAN
Date: Mon, 22 Sep 2014 14:42:39 -0700
Message-Id: <1411422159-25534-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can run qcom platforms in big-endian mode. Select the option.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

It's sad that we have to select this Kconfig. I'm tempted to remove
the config given that we don't have anything like this for other things
like LPAE support. Anyway, this is required to actually test big-endian
on qcom platforms.

 arch/arm/mach-qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
index ee5697ba05bc..29aa8e1970b0 100644
--- a/arch/arm/mach-qcom/Kconfig
+++ b/arch/arm/mach-qcom/Kconfig
@@ -1,6 +1,7 @@
 menuconfig ARCH_QCOM
 	bool "Qualcomm Support" if ARCH_MULTI_V7
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_GIC
 	select ARM_AMBA
 	select CLKSRC_OF
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

