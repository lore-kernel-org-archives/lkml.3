Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaDHIUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:20:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbaDHIUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:20:39 -0400
Date: Tue, 8 Apr 2014 10:20:36 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] phy: restore OMAP_CONTROL_PHY dependencies
Message-ID: <20140408102036.2de12394@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When OMAP_CONTROL_USB was renamed to OMAP_CONTROL_PHY (commit
14da699b), its dependencies were lost in the process. Nothing in the
commit message indicates that this removal was intentional, so I think
it was by accident and the dependencies should be restored.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.15-rc0.orig/drivers/phy/Kconfig	2014-04-07 10:23:06.031199592 +0200
+++ linux-3.15-rc0/drivers/phy/Kconfig	2014-04-08 10:12:16.448317340 +0200
@@ -33,6 +33,7 @@ config PHY_MVEBU_SATA
 
 config OMAP_CONTROL_PHY
 	tristate "OMAP CONTROL PHY Driver"
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  Enable this to add support for the PHY part present in the control
 	  module. This driver has API to power on the USB2 PHY and to write to


-- 
Jean Delvare
SUSE L3 Support
