Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3APOP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:15:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55975 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3APOP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:15:57 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] mfd: twl4030-madc: Remove leftover __exit_p()
Date: Wed, 16 Jan 2013 15:15:53 +0100
Message-ID: <1358345753-31557-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__exit_p() need to be removed after the __devexit removal from the driver.

Fixes the following compile time warning:
drivers/mfd/twl4030-madc.c:788:12: warning: ?twl4030_madc_remove? defined but not used [-Wunused-function]

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-madc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 88ff9dc..942b666 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -800,7 +800,7 @@ static int twl4030_madc_remove(struct platform_device *pdev)
 
 static struct platform_driver twl4030_madc_driver = {
 	.probe = twl4030_madc_probe,
-	.remove = __exit_p(twl4030_madc_remove),
+	.remove = twl4030_madc_remove,
 	.driver = {
 		   .name = "twl4030_madc",
 		   .owner = THIS_MODULE,
-- 
1.8.1

