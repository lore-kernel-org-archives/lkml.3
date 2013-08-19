Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab3HSIwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:52:09 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:59239 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055Ab3HSIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:52:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="29716861"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] regulator: ti-abb: simplify platform_get_resource_byname/devm_ioremap_resource
Date: Mon, 19 Aug 2013 10:51:55 +0200
Message-Id: <1376902316-18520-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource_byname when the value is passed to devm_ioremap_resource.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,e,e1;
expression ret != 0;
identifier l;
@@

  res = platform_get_resource_byname(...);
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/regulator/ti-abb-regulator.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 3753ed0..d8e3e12 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -717,11 +717,6 @@ static int ti_abb_probe(struct platform_device *pdev)
 	/* Map ABB resources */
 	pname = "base-address";
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
-	if (!res) {
-		dev_err(dev, "Missing '%s' IO resource\n", pname);
-		ret = -ENODEV;
-		goto err;
-	}
 	abb->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(abb->base)) {
 		ret = PTR_ERR(abb->base);
@@ -770,11 +765,6 @@ static int ti_abb_probe(struct platform_device *pdev)
 
 	pname = "ldo-address";
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
-	if (!res) {
-		dev_dbg(dev, "Missing '%s' IO resource\n", pname);
-		ret = -ENODEV;
-		goto skip_opt;
-	}
 	abb->ldo_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(abb->ldo_base)) {
 		ret = PTR_ERR(abb->ldo_base);

