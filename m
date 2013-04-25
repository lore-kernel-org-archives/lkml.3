Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3DYJcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:32:19 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42369 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3DYJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:32:18 -0400
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 17:32:16 +0800
Message-ID: <CAPgLHd84am=zc=TsknRqSTL=98qr-wwDOOjQJEQAYOeQZtosVA@mail.gmail.com>
Subject: [PATCH -next] staging: ozwpan: fix error return code in oz_cdev_register()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: rupesh.gujare@atmel.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/ozwpan/ozcdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 27d0666..8dc24ea 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -355,11 +355,13 @@ int oz_cdev_register(void)
 	g_oz_class = class_create(THIS_MODULE, "ozmo_wpan");
 	if (IS_ERR(g_oz_class)) {
 		oz_trace("Failed to register ozmo_wpan class\n");
+		err = PTR_ERR(g_oz_class);
 		goto out1;
 	}
 	dev = device_create(g_oz_class, NULL, g_cdev.devnum, NULL, "ozwpan");
 	if (IS_ERR(dev)) {
 		oz_trace("Failed to create sysfs entry for cdev\n");
+		err = PTR_ERR(dev);
 		goto out1;
 	}
 	return 0;

