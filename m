Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3KKQxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:53:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44344 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab3KKQxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:53:00 -0500
From: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: [PATCH 01/12] mtd: nand: davinci: fix driver registration
Thread-Topic: [PATCH 01/12] mtd: nand: davinci: fix driver registration
Thread-Index: AQHO3vreJ5+VtxWQn0C87wlcEPbOHpogPmEV
Date: Mon, 11 Nov 2013 16:52:05 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8CE2@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-2-git-send-email-ivan.khoronzhuk@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When kernel is booted using DT, there is no guarantee that Davinci
NAND device has been created already at the time when driver init
function is executed. Therefore, platform_driver_probe() can't be used
because this may result the Davinci NAND driver will never be probed.
The driver probing has to be made with core mechanism.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
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
+       .probe          = nand_davinci_probe,
        .remove         = __exit_p(nand_davinci_remove),
        .driver         = {
                .name   = "davinci_nand",
@@ -886,7 +887,7 @@ static struct platform_driver nand_davinci_driver = {
 };
 MODULE_ALIAS("platform:davinci_nand");

-module_platform_driver_probe(nand_davinci_driver, nand_davinci_probe);
+module_platform_driver(nand_davinci_driver);

 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Texas Instruments");
--
1.7.9.5

