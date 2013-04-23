Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3DWNVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:21:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38716 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab3DWNVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:21:02 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mfd: twl-core: convert to module_i2c_driver()
Date: Tue, 23 Apr 2013 16:19:10 +0300
Message-ID: <1366723151-23209-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shift TWL initialization to module/device init layer, because I2C now is
not initialized on subsys init layer and shifted to module/device init
layer instead.

The I2C <--> TWL dependency should be resolved in drivers/Makefile now.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/mfd/twl-core.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 4f3baad..f01340d 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1347,17 +1347,7 @@ static struct i2c_driver twl_driver = {
 	.remove		= twl_remove,
 };
 
-static int __init twl_init(void)
-{
-	return i2c_add_driver(&twl_driver);
-}
-subsys_initcall(twl_init);
-
-static void __exit twl_exit(void)
-{
-	i2c_del_driver(&twl_driver);
-}
-module_exit(twl_exit);
+module_i2c_driver(twl_driver);
 
 MODULE_AUTHOR("Texas Instruments, Inc.");
 MODULE_DESCRIPTION("I2C Core interface for TWL");
-- 
1.7.9.5

