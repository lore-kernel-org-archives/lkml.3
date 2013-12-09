Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab3LIQ0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:26:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56412 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879Ab3LIQWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:22:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: <lee.jones@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 02/15] mfd: menelaus: Switch over to module_i2c_driver
Date: Mon, 9 Dec 2013 10:21:12 -0600
Message-ID: <1386606085-26838-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386606085-26838-1-git-send-email-balbi@ti.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a macro to remove some boilerplate code, no functional changes.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 975ff9e..8bd97ca 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1287,29 +1287,8 @@ static struct i2c_driver menelaus_i2c_driver = {
 	.id_table	= menelaus_id,
 };
 
-static int __init menelaus_init(void)
-{
-	int res;
-
-	res = i2c_add_driver(&menelaus_i2c_driver);
-	if (res < 0) {
-		pr_err(DRIVER_NAME ": driver registration failed\n");
-		return res;
-	}
-
-	return 0;
-}
-
-static void __exit menelaus_exit(void)
-{
-	i2c_del_driver(&menelaus_i2c_driver);
-
-	/* FIXME: Shutdown menelaus parts that can be shut down */
-}
+module_i2c_driver(menelaus_i2c_driver);
 
 MODULE_AUTHOR("Texas Instruments, Inc. (and others)");
 MODULE_DESCRIPTION("I2C interface for Menelaus.");
 MODULE_LICENSE("GPL");
-
-module_init(menelaus_init);
-module_exit(menelaus_exit);
-- 
1.8.4.GIT

