Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3IXIyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:54:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46216 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3IXIye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:54:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <p.zabel@pengutronix.de>, <broonie@kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 01/10] usb: phy: generic: Add gpio_reset to platform data
Date: Tue, 24 Sep 2013 11:53:47 +0300
Message-ID: <1380012836-29900-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1380012836-29900-1-git-send-email-rogerq@ti.com>
References: <1380012836-29900-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO number of the RESET line can be passed to the
driver using the gpio_reset member.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 include/linux/usb/usb_phy_gen_xceiv.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/usb/usb_phy_gen_xceiv.h b/include/linux/usb/usb_phy_gen_xceiv.h
index f9a7e7b..42f3b71 100644
--- a/include/linux/usb/usb_phy_gen_xceiv.h
+++ b/include/linux/usb/usb_phy_gen_xceiv.h
@@ -9,7 +9,8 @@ struct usb_phy_gen_xceiv_platform_data {
 
 	/* if set fails with -EPROBE_DEFER if can't get regulator */
 	unsigned int needs_vcc:1;
-	unsigned int needs_reset:1;
+	unsigned int needs_reset:1;	/* deprecated */
+	int gpio_reset;
 };
 
 #if IS_ENABLED(CONFIG_NOP_USB_XCEIV)
-- 
1.7.4.1

