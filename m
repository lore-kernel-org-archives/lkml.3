Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbaFSStb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:49:31 -0400
Received: from sauhun.de ([89.238.76.85]:37037 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933872AbaFSSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:49:29 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@sang-engineering.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 2/3] bus: brcmstb_gisb: Use devm_ioremap_resource
Date: Thu, 19 Jun 2014 20:49:00 +0200
Message-Id: <1403203741-5113-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa@sang-engineering.com>

devm_request_and_ioremap is deprecated.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/bus/brcmstb_gisb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
index 6159b7752a64..f2cd6a2d40b4 100644
--- a/drivers/bus/brcmstb_gisb.c
+++ b/drivers/bus/brcmstb_gisb.c
@@ -212,9 +212,9 @@ static int brcmstb_gisb_arb_probe(struct platform_device *pdev)
 	mutex_init(&gdev->lock);
 	INIT_LIST_HEAD(&gdev->next);
 
-	gdev->base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!gdev->base)
-		return -ENOMEM;
+	gdev->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(gdev->base))
+		return PTR_ERR(gdev->base);
 
 	err = devm_request_irq(&pdev->dev, timeout_irq,
 				brcmstb_gisb_timeout_handler, 0, pdev->name,
-- 
2.0.0

