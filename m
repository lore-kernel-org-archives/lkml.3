Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3AWKmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:42:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42466 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab3AWKjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:39:02 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 11/20] mfd: omap_usb_host: Avoid missing platform data checks in suspend/resume
Date: Wed, 23 Jan 2013 12:38:03 +0200
Message-ID: <1358937492-8129-12-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the unnecessary missing platform data checks
in runtime_suspend/resume. We are already checking for missing
platform data in probe.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index d6e6b8c..061366d 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -277,11 +277,6 @@ static int usbhs_runtime_resume(struct device *dev)
 
 	dev_dbg(dev, "usbhs_runtime_resume\n");
 
-	if (!pdata) {
-		dev_dbg(dev, "missing platform_data\n");
-		return  -ENODEV;
-	}
-
 	omap_tll_enable();
 	spin_lock_irqsave(&omap->lock, flags);
 
@@ -309,11 +304,6 @@ static int usbhs_runtime_suspend(struct device *dev)
 
 	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
-	if (!pdata) {
-		dev_dbg(dev, "missing platform_data\n");
-		return  -ENODEV;
-	}
-
 	spin_lock_irqsave(&omap->lock, flags);
 
 	if (is_ehci_tll_mode(pdata->port_mode[0]))
-- 
1.7.4.1

