Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3EJIRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:06 -0400
Received: from sauhun.de ([89.238.76.85]:60457 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3EJIQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:59 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Viresh Kumar <viresh.linux@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC 19/42] drivers/pinctrl/spear: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:04 +0200
Message-Id: <1368173847-5661-20-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/pinctrl/spear/pinctrl-plgpio.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 3e5a887..6b090be 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -528,18 +528,13 @@ static int plgpio_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret, irq, i;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "invalid IORESOURCE_MEM\n");
-		return -EBUSY;
-	}
-
 	plgpio = devm_kzalloc(&pdev->dev, sizeof(*plgpio), GFP_KERNEL);
 	if (!plgpio) {
 		dev_err(&pdev->dev, "memory allocation fail\n");
 		return -ENOMEM;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	plgpio->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(plgpio->base))
 		return PTR_ERR(plgpio->base);
-- 
1.7.10.4

