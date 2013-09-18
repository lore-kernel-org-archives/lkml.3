Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3IRSto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:49:44 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:37088 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3IRStk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:49:40 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: patches@linaro.org, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH] arm: mvebu: use the main timer as clock source from DT
Date: Wed, 18 Sep 2013 20:49:28 +0200
Message-Id: <1379530168-9359-1-git-send-email-jean.pihet@linaro.org>
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
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 41c6946..971d796 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -26,6 +26,7 @@ config DW_APB_TIMER_OF
 
 config ARMADA_370_XP_TIMER
 	bool
+	select CLKSRC_OF
 
 config ORION_TIMER
 	select CLKSRC_OF
-- 
1.7.11.7

