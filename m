Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3IJFPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:15:45 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33568 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3IJFPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:15:44 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: mfm@muteddisk.com, linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH 2/3] staging: usbip: vhci_hcd: correctly handle return value
Date: Tue, 10 Sep 2013 10:43:39 +0530
Message-Id: <1378790019-3493-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret == 0 means success, anything else is failure.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/usbip/vhci_hcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index d7974cb..b3c9217 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -1146,11 +1146,11 @@ static int __init vhci_hcd_init(void)
 		return -ENODEV;
 
 	ret = platform_driver_register(&vhci_driver);
-	if (ret < 0)
+	if (ret)
 		goto err_driver_register;
 
 	ret = platform_device_register(&the_pdev);
-	if (ret < 0)
+	if (ret)
 		goto err_platform_device_register;
 
 	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
-- 
1.7.10.4

