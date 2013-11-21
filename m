Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3KUL30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:29:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50526 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab3KUL3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:29:24 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v2 01/10] mtd: nand: davinci: fix driver registration
Date: Thu, 21 Nov 2013 13:28:16 +0200
Message-ID: <1385033305-13179-2-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kernel is booted using DT, there is no guarantee that Davinci
NAND device has been created already at the time when driver init
function is executed. Therefore, platform_driver_probe() can't be used
because this may result the Davinci NAND driver will never be probed.
The driver probing has to be made with core mechanism.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index b77a01e..d87213f 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -877,6 +877,7 @@ static int __exit nand_davinci_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver nand_davinci_driver = {
+	.probe		= nand_davinci_probe,
 	.remove		= __exit_p(nand_davinci_remove),
 	.driver		= {
 		.name	= "davinci_nand",
@@ -886,7 +887,7 @@ static struct platform_driver nand_davinci_driver = {
 };
 MODULE_ALIAS("platform:davinci_nand");
 
-module_platform_driver_probe(nand_davinci_driver, nand_davinci_probe);
+module_platform_driver(nand_davinci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Texas Instruments");
-- 
1.7.9.5

