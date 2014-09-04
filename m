Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaIDQqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:46:06 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60630 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaIDQqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:46:04 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-iio@vger.kernel.org (open list:STAGING - INDUSTR...),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: iio: adc: mxs-lradc.c: sparse warning of incorrect type
Date: Thu,  4 Sep 2014 22:15:42 +0530
Message-Id: <1409849142-12185-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning : incorrect type in argument 1 
		       (different address spaces)

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/iio/adc/mxs-lradc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 468327f..d8d1fe1 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -1545,9 +1545,12 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 	/* Grab the memory area */
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lradc->dev = &pdev->dev;
-	lradc->base = devm_ioremap_resource(dev, iores);
-	if (IS_ERR(lradc->base))
-		return PTR_ERR(lradc->base);
+	void *tempptr;
+
+	tempptr = devm_ioremap_resource(dev, iores);
+	if (IS_ERR(tempptr))
+		return PTR_ERR(tempptr);
+	lradc->base = tempptr;
 
 	lradc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(lradc->clk)) {
-- 
1.8.1.2

