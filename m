Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaKQNdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:33:19 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48574 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbaKQNdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:33:15 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, kishon@ti.com, p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>, arnd@arndb.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] phy: berlin_usb: depends on RESET_CONTROLLER
Date: Mon, 17 Nov 2014 14:33:11 +0100
Message-Id: <1416231192-27056-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Berlin USB PHY driver uses the Berlin reset controller
unconditionally. Make it depending on RESET_CONTROLLER.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index b6da75f563e7..38ca6ff00aef 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -17,7 +17,7 @@ config GENERIC_PHY
 
 config PHY_BERLIN_USB
 	tristate "Marvell Berlin USB PHY Driver"
-	depends on ARCH_BERLIN && HAS_IOMEM && OF
+	depends on ARCH_BERLIN && RESET_CONTROLLER && HAS_IOMEM && OF
 	select GENERIC_PHY
 	help
 	  Enable this to support the USB PHY on Marvell Berlin SoCs.
-- 
2.1.0

