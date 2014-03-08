Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaCHJcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:32:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52792 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaCHJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:30:13 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/28] phy: omap: Depend on OMAP_OCP2SCP bus driver
Date: Sat, 8 Mar 2014 14:59:27 +0530
Message-ID: <1394270969-11851-27-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

The OMAP_USB2 and OMAP_PIPE3 PHY devices will not be
detected if the OMAP_OCP2SCP bus driver is not present.
Make them depend on it.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index fe8c009..2aead8b 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -47,6 +47,7 @@ config OMAP_USB2
 	depends on USB_PHY
 	select GENERIC_PHY
 	select OMAP_CONTROL_PHY
+	depends on OMAP_OCP2SCP
 	help
 	  Enable this to support the transceiver that is part of SOC. This
 	  driver takes care of all the PHY functionality apart from comparator.
@@ -58,6 +59,7 @@ config TI_PIPE3
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	select GENERIC_PHY
 	select OMAP_CONTROL_PHY
+	depends on OMAP_OCP2SCP
 	help
 	  Enable this to support the PIPE3 PHY that is part of TI SOCs. This
 	  driver takes care of all the PHY functionality apart from comparator.
-- 
1.7.9.5

