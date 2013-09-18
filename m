Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3IRPyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:54:01 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:54269 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3IRPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:53:58 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: patches@linaro.org, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] arm: mvebu: use the main timer as clock source from DT
Date: Wed, 18 Sep 2013 17:53:44 +0200
Message-Id: <1379519624-4267-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:
  573145f08c2b92c45498468afbbba909f6ce6135
  clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE

replaced a call to the driver's timer initialization by a call to
clocksource_of_init(). However, it failed to select CONFIG_CLKSRC_OF.

Fix this by selecting CONFIG_CLKSRC_OF for Armada370/XP machines.
Without this change the kernel is stuck at: 'Calibrating delay loop...'.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 arch/arm/mach-mvebu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index 9eb63d7..25e6c00 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -26,6 +26,7 @@ config MACH_ARMADA_370_XP
 	select HAVE_SMP
 	select CACHE_L2X0
 	select CPU_PJ4B
+	select CLKSRC_OF
 
 config MACH_ARMADA_370
 	bool "Marvell Armada 370 boards"
-- 
1.7.11.7

