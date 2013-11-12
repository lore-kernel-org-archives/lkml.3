Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3KLTJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:09:25 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:39461 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3KLTHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:36 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 11/12] usb: gadget: Remove superfluous name casts
Date: Tue, 12 Nov 2013 20:07:24 +0100
Message-Id: <1384283245-9419-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/fsl_qe_udc.c   |    2 +-
 drivers/usb/gadget/fsl_udc_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 807127d56fa3..6315ee698d4d 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2717,7 +2717,7 @@ MODULE_DEVICE_TABLE(of, qe_udc_match);
 
 static struct platform_driver udc_driver = {
 	.driver = {
-		.name = (char *)driver_name,
+		.name = driver_name,
 		.owner = THIS_MODULE,
 		.of_match_table = qe_udc_match,
 	},
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 36ac7cfba91d..b7dea4eec32c 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2666,7 +2666,7 @@ static struct platform_driver udc_driver = {
 	.suspend	= fsl_udc_suspend,
 	.resume		= fsl_udc_resume,
 	.driver		= {
-			.name = (char *)driver_name,
+			.name = driver_name,
 			.owner = THIS_MODULE,
 			/* udc suspend/resume called from OTG driver */
 			.suspend = fsl_udc_otg_suspend,
-- 
1.7.9.5

