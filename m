Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaDSDWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:22:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47665 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbaDSDVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:21:50 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] phy: restore OMAP_CONTROL_PHY dependencies
Date: Sat, 19 Apr 2014 08:51:42 +0530
Message-ID: <1397877704-2755-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397877704-2755-1-git-send-email-kishon@ti.com>
References: <1397877704-2755-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

When OMAP_CONTROL_USB was renamed to OMAP_CONTROL_PHY (commit
14da699b), its dependencies were lost in the process. Nothing in the
commit message indicates that this removal was intentional, so I think
it was by accident and the dependencies should be restored.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Roger Quadros <rogerq@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 3bb05f1..4906c27 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -33,6 +33,7 @@ config PHY_MVEBU_SATA
 
 config OMAP_CONTROL_PHY
 	tristate "OMAP CONTROL PHY Driver"
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  Enable this to add support for the PHY part present in the control
 	  module. This driver has API to power on the USB2 PHY and to write to
-- 
1.7.9.5

