Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935745Ab3DPIaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:30:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34143 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934736Ab3DPIat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:30:49 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@iki.fi>
Subject: [PATCH v2 2/2] RTC: rtc-twl: Cleanup with module_platform_driver() conversion
Date: Tue, 16 Apr 2013 10:30:13 +0200
Message-ID: <1366101013-21183-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366101013-21183-1-git-send-email-peter.ujfalusi@ti.com>
References: <1366101013-21183-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use module_platform_driver() to register the platform driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/rtc/rtc-twl.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index c385e9b..22b2fd6 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -618,17 +618,7 @@ static struct platform_driver twl4030rtc_driver = {
 	},
 };
 
-static int __init twl_rtc_init(void)
-{
-	return platform_driver_register(&twl4030rtc_driver);
-}
-module_init(twl_rtc_init);
-
-static void __exit twl_rtc_exit(void)
-{
-	platform_driver_unregister(&twl4030rtc_driver);
-}
-module_exit(twl_rtc_exit);
+module_platform_driver(twl4030rtc_driver);
 
 MODULE_AUTHOR("Texas Instruments, MontaVista Software");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

