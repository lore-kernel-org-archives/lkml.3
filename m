Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaCFOYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:24:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45627 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbaCFOYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:24:16 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.comg>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 09/13] phy: omap: Depend on OMAP_OCP2SCP bus driver
Date: Thu, 6 Mar 2014 16:23:01 +0200
Message-ID: <1394115785-28301-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394115785-28301-1-git-send-email-rogerq@ti.com>
References: <1394115785-28301-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP_USB2 and OMAP_PIPE3 PHY devices will not be
detected if the OMAP_OCP2SCP bus driver is not present.
Make them depend on it.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/Kconfig | 2 ++
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
1.8.3.2

