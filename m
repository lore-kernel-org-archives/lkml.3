Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaF2HSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:18:22 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56251 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaF2HSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:18:21 -0400
Date: Sun, 29 Jun 2014 12:48:15 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] pinctrl: berlin: fix return value for dev_get_regmap
Message-ID: <20140629071815.GA16257@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The failure value of dev_get_regmap is NULL. Hence, the return value is
changed to -ENODEV.

A simplified version of the semantic match that finds this problem is as
follows:

// <smpl>
@@
expression e1;
@@

* if (!e1)
  return PTR_ERR(e1);

// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/pinctrl/berlin/berlin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
1.9.1

