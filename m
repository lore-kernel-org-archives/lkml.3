Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab3FMIsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:48:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53147 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337Ab3FMIpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:45:12 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <sylvester.nawrocki@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: [PATCH v7 4/9] usb: phy: twl4030: twl4030 shouldn't be subsys_initcall
Date: Thu, 13 Jun 2013 14:13:54 +0530
Message-ID: <1371113039-5784-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371113039-5784-1-git-send-email-kishon@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the inticall from subsys_initcall to module_init for
twl4030-usb.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/phy/phy-twl4030-usb.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
index 65a5e43..fba9697 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/usb/phy/phy-twl4030-usb.c
@@ -822,17 +822,7 @@ static struct platform_driver twl4030_usb_driver = {
 	},
 };
 
-static int __init twl4030_usb_init(void)
-{
-	return platform_driver_register(&twl4030_usb_driver);
-}
-subsys_initcall(twl4030_usb_init);
-
-static void __exit twl4030_usb_exit(void)
-{
-	platform_driver_unregister(&twl4030_usb_driver);
-}
-module_exit(twl4030_usb_exit);
+module_platform_driver(twl4030_usb_driver);
 
 MODULE_ALIAS("platform:twl4030_usb");
 MODULE_AUTHOR("Texas Instruments, Inc, Nokia Corporation");
-- 
1.7.10.4

