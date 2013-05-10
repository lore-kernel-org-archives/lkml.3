Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3EJIbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:31:33 -0400
Received: from sauhun.de ([89.238.76.85]:60393 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab3EJIQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:41 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [RFC 11/42] drivers/input/serio: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:56 +0200
Message-Id: <1368173847-5661-12-git-send-email-wsa@the-dreams.de>
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
 drivers/input/serio/arc_ps2.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
index 3fb7727..8024a6d 100644
--- a/drivers/input/serio/arc_ps2.c
+++ b/drivers/input/serio/arc_ps2.c
@@ -189,12 +189,6 @@ static int arc_ps2_probe(struct platform_device *pdev)
 	int irq;
 	int error, id, i;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no IO memory defined\n");
-		return -EINVAL;
-	}
-
 	irq = platform_get_irq_byname(pdev, "arc_ps2_irq");
 	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ defined\n");
@@ -208,6 +202,7 @@ static int arc_ps2_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	arc_ps2->addr = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(arc_ps2->addr))
 		return PTR_ERR(arc_ps2->addr);
-- 
1.7.10.4

