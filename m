Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbbATXMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:12:53 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:47012 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbATXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:12:52 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH] ARM: vf610: use SMP_ON_UP for Vybrid SoC
Date: Wed, 21 Jan 2015 00:12:45 +0100
Message-Id: <1421795565-3370-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Vybrid SoC has only one Cortex-A5 core and hence should select
the SMP_ON_UP configuration on a SMP kernel.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index e8627e0..b8d3ccd 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -634,6 +634,7 @@ config SOC_VF610
 	select ARM_GIC
 	select PINCTRL_VF610
 	select PL310_ERRATA_769419 if CACHE_L2X0
+	select SMP_ON_UP if SMP
 
 	help
 	  This enable support for Freescale Vybrid VF610 processor.
-- 
2.2.2

