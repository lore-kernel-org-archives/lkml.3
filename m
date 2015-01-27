Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbbA0Bpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:45:44 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:44486 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbbA0Bpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:45:40 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Cc: Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ola Jeppson <ola@adapteva.com>,
        linux-gpio@vger.kernel.org, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] usb: phy-generic: Don't fail on missing gpio reset
Date: Mon, 26 Jan 2015 17:45:29 -0800
Message-Id: <1422323129-20969-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.2.1.g63c5777
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A reset through a GPIO is optional. Don't fail probing when it is
missing.

Reported-by: Andreas Färber <afaerber@suse.de>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi Andreas,

does this do the trick?

	Thanks,
	Sören

 drivers/usb/phy/phy-generic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index dd05254241fb..a73d4c738f0b 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -241,10 +241,8 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop,
 
 	if (err == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
-	if (err) {
-		dev_err(dev, "Error requesting RESET GPIO\n");
-		return err;
-	}
+	if (err)
+		nop->gpiod_reset = NULL;
 
 	nop->phy.otg = devm_kzalloc(dev, sizeof(*nop->phy.otg),
 			GFP_KERNEL);
-- 
2.2.2.1.g63c5777

