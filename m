Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbaGRJb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:31:58 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56579 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbaGRJb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:31:56 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 8/9] usb: phy: am335x: call usb_gen_phy_init()/usb_gen_phy_shutdown() in am335x_init()/am335x_shutdown()
Date: Fri, 18 Jul 2014 11:31:29 +0200
Message-Id: <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to use the musb driver with HW that
requires external regulators or clocks.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/phy/phy-am335x.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index 6522fa7..de25674 100644
--- a/drivers/usb/phy/phy-am335x.c
+++ b/drivers/usb/phy/phy-am335x.c
@@ -22,6 +22,7 @@ static int am335x_init(struct usb_phy *phy)
 {
 	struct am335x_phy *am_phy = dev_get_drvdata(phy->dev);
 
+	usb_gen_phy_init(phy);
 	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, true);
 	return 0;
 }
@@ -31,6 +32,7 @@ static void am335x_shutdown(struct usb_phy *phy)
 	struct am335x_phy *am_phy = dev_get_drvdata(phy->dev);
 
 	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, false);
+	usb_gen_phy_shutdown(phy);
 }
 
 static int am335x_phy_probe(struct platform_device *pdev)
-- 
1.7.10.4

