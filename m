Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3KNMwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:52:39 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:53418 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3KNMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:52:36 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] mfd: syscon: Allow to using subdevices
Date: Thu, 14 Nov 2013 16:52:03 +0400
Message-Id: <1384433523-30602-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for using subdevices within syscon node.
Primary usage of this is describe all devices with same memory
region in one container.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/syscon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 71841f9..6e9244a 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -152,6 +152,9 @@ static int syscon_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, syscon);
 
+	if (of_platform_populate(dev->of_node, NULL, NULL, dev))
+		dev_warn(dev, "Fail to create subdevices\n");
+
 	dev_info(dev, "regmap %pR registered\n", res);
 
 	return 0;
-- 
1.8.1.5

