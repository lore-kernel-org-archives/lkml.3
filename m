Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3FFIO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:14:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37247 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3FFIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:14:21 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tony Lindgren <tony@atomide.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH v3 2/2] RTC: rtc-twl: Cleanup with module_platform_driver() conversion
Date: Thu, 6 Jun 2013 10:13:38 +0200
Message-ID: <1370506418-1491-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370506418-1491-1-git-send-email-peter.ujfalusi@ti.com>
References: <1370506418-1491-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use module_platform_driver() to register the platform driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/rtc/rtc-twl.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index c9060e9..e1776fd 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -614,17 +614,7 @@ static struct platform_driver twl4030rtc_driver = {
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
1.8.2.1

