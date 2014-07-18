Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbaGRJcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:32:08 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56586 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761000AbaGRJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:32:05 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 7/9] usb: phy: am335x: setup the gen_phy function pointers _before_ adding the phy
Date: Fri, 18 Jul 2014 11:31:28 +0200
Message-Id: <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure all parameters are correctly set up before registering the
PHY with the USB framework.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/phy/phy-am335x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index 91c71ab..6522fa7 100644
--- a/drivers/usb/phy/phy-am335x.c
+++ b/drivers/usb/phy/phy-am335x.c
@@ -56,11 +56,12 @@ static int am335x_phy_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	am_phy->usb_phy_gen.phy.init = am335x_init;
+	am_phy->usb_phy_gen.phy.shutdown = am335x_shutdown;
+
 	ret = usb_add_phy_dev(&am_phy->usb_phy_gen.phy);
 	if (ret)
 		return ret;
-	am_phy->usb_phy_gen.phy.init = am335x_init;
-	am_phy->usb_phy_gen.phy.shutdown = am335x_shutdown;
 
 	platform_set_drvdata(pdev, am_phy);
 	device_init_wakeup(dev, true);
-- 
1.7.10.4

