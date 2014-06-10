Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaFJLQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:16:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:52044 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaFJLQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:16:34 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] ARM: qcom: select GSBI from mach kconfig
Date: Tue, 10 Jun 2014 12:16:20 +0100
Message-Id: <1402398980-24664-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds GSBI selection automatically from mach kconfig, As GSBI
seems to be the very basic SOC specific driver and serial driver depends on it.
I think this option should be selected via mach kconfig rather than adding
it to any defconfig.

Without this patch multi_v7_defconfig can not show up console on
IFC6410.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/mach-qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
index 5bac591..d68d7ee 100644
--- a/arch/arm/mach-qcom/Kconfig
+++ b/arch/arm/mach-qcom/Kconfig
@@ -7,6 +7,7 @@ config ARCH_QCOM
 	select GENERIC_CLOCKEVENTS
 	select HAVE_SMP
 	select QCOM_SCM if SMP
+	select QCOM_GSBI
 	help
 	  Support for Qualcomm's devicetree based systems.
 
-- 
1.9.1

