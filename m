Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3CRXTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:19:11 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:41450 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3CRXTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:19:10 -0400
From: Ben Collins <benmcollins13@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] sgy-cts1000: Remove __dev* attributes
Date: Mon, 18 Mar 2013 19:19:07 -0400
Message-Id: <1A7562E2-E3F4-499C-AB2E-788D08234B02@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow the driver snuck in with these still in it.

Signed-off-by: Ben Collins <ben.c@servergy.com>
---
 arch/powerpc/platforms/85xx/sgy_cts1000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/sgy_cts1000.c b/arch/powerpc/platforms/85xx/sgy_cts1000.c
index 611e92f..7179726 100644
--- a/arch/powerpc/platforms/85xx/sgy_cts1000.c
+++ b/arch/powerpc/platforms/85xx/sgy_cts1000.c
@@ -69,7 +69,7 @@ static irqreturn_t gpio_halt_irq(int irq, void *__data)
         return IRQ_HANDLED;
 };
 
-static int __devinit gpio_halt_probe(struct platform_device *pdev)
+static int gpio_halt_probe(struct platform_device *pdev)
 {
 	enum of_gpio_flags flags;
 	struct device_node *node = pdev->dev.of_node;
@@ -128,7 +128,7 @@ static int __devinit gpio_halt_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit gpio_halt_remove(struct platform_device *pdev)
+static int gpio_halt_remove(struct platform_device *pdev)
 {
 	if (halt_node) {
 		int gpio = of_get_gpio(halt_node, 0);
@@ -165,7 +165,7 @@ static struct platform_driver gpio_halt_driver = {
 		.of_match_table = gpio_halt_match,
 	},
 	.probe		= gpio_halt_probe,
-	.remove		= __devexit_p(gpio_halt_remove),
+	.remove		= gpio_halt_remove,
 };
 
 module_platform_driver(gpio_halt_driver);
-- 
1.8.1.2


--
Servergy  : http://www.servergy.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

