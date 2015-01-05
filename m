Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbbAENKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:10:11 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:58822 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbbAENKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:10:08 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: omap2: Fix typo in tvc_probe_pdata
Date: Mon,  5 Jan 2015 14:09:47 +0100
Message-Id: <1420463387-26391-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigning ddata->invert_polarity to itself is not very useful; the
context suggests that the right-hand side should have been
pdata->invert_polarity.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
index 9a2b5ce58545..8511c648a15c 100644
--- a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
+++ b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
@@ -208,7 +208,7 @@ static int tvc_probe_pdata(struct platform_device *pdev)
 	ddata->in = in;
 
 	ddata->connector_type = pdata->connector_type;
-	ddata->invert_polarity = ddata->invert_polarity;
+	ddata->invert_polarity = pdata->invert_polarity;
 
 	dssdev = &ddata->dssdev;
 	dssdev->name = pdata->name;
-- 
2.1.3

