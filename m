Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaFKIQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:16:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35254 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbaFKIQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:16:20 -0400
Date: Wed, 11 Jun 2014 11:15:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pinctrl: berlin: fix an error code in berlin_pinctrl_probe()
Message-ID: <20140611081513.GA29572@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are returning success here because PTR_ERR(NULL) is zero.  We should
be returning -ENODEV.

Fixes: 3de68d331c24 ('pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c
index edf5d2f..86db223 100644
--- a/drivers/pinctrl/berlin/berlin.c
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -320,7 +320,7 @@ int berlin_pinctrl_probe(struct platform_device *pdev,
 
 	regmap = dev_get_regmap(&pdev->dev, NULL);
 	if (!regmap)
-		return PTR_ERR(regmap);
+		return -ENODEV;
 
 	pctrl = devm_kzalloc(dev, sizeof(*pctrl), GFP_KERNEL);
 	if (!pctrl)
