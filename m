Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3EJI1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:27:30 -0400
Received: from sauhun.de ([89.238.76.85]:60481 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab3EJIRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:04 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 21/42] drivers/remoteproc: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:06 +0200
Message-Id: <1368173847-5661-22-git-send-email-wsa@the-dreams.de>
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
 drivers/remoteproc/da8xx_remoteproc.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/remoteproc/da8xx_remoteproc.c b/drivers/remoteproc/da8xx_remoteproc.c
index 9b2e60a..95cedf5 100644
--- a/drivers/remoteproc/da8xx_remoteproc.c
+++ b/drivers/remoteproc/da8xx_remoteproc.c
@@ -201,23 +201,11 @@ static int da8xx_rproc_probe(struct platform_device *pdev)
 	}
 
 	bootreg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!bootreg_res) {
-		dev_err(dev,
-			"platform_get_resource(IORESOURCE_MEM, 0): NULL\n");
-		return -EADDRNOTAVAIL;
-	}
-
-	chipsig_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!chipsig_res) {
-		dev_err(dev,
-			"platform_get_resource(IORESOURCE_MEM, 1): NULL\n");
-		return -EADDRNOTAVAIL;
-	}
-
 	bootreg = devm_ioremap_resource(dev, bootreg_res);
 	if (IS_ERR(bootreg))
 		return PTR_ERR(bootreg);
 
+	chipsig_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	chipsig = devm_ioremap_resource(dev, chipsig_res);
 	if (IS_ERR(chipsig))
 		return PTR_ERR(chipsig);
-- 
1.7.10.4

