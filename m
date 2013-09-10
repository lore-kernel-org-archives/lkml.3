Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab3IJFQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:16:13 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36057 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3IJFQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:16:10 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: mfm@muteddisk.com, linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH 1/3] staging: usbip: stub_main: correctly handle return value
Date: Tue, 10 Sep 2013 10:44:07 +0530
Message-Id: <1378790047-3530-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret == 0 means success, anything else is failure.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/usbip/stub_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 33027cc..baf857f 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -255,14 +255,14 @@ static int __init usbip_host_init(void)
 	}
 
 	ret = usb_register(&stub_driver);
-	if (ret < 0) {
+	if (ret) {
 		pr_err("usb_register failed %d\n", ret);
 		goto err_usb_register;
 	}
 
 	ret = driver_create_file(&stub_driver.drvwrap.driver,
 				 &driver_attr_match_busid);
-	if (ret < 0) {
+	if (ret) {
 		pr_err("driver_create_file failed\n");
 		goto err_create_file;
 	}
-- 
1.7.10.4

