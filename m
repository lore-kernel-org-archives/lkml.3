Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3K0DfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:35:03 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:53846 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3K0De7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:34:59 -0500
MIME-Version: 1.0
Date: Wed, 27 Nov 2013 11:34:58 +0800
Message-ID: <CAPgLHd8Pm5+g-m2FJ_oqQxtQ8Ewxafx=DTyd8Mm_YCgYGLqDKw@mail.gmail.com>
Subject: [PATCH -next] platform/chrome: unregister platform driver/device when
 module exit
From: Wei Yongjun <weiyj.lk@gmail.com>
To: olof@lixom.net
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

We have registered platform driver and device when module
init, and need unregister them when module exit.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/platform/chrome/chromeos_laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 446ef0f..7f3aad0 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -511,6 +511,9 @@ static void __exit chromeos_laptop_exit(void)
 		i2c_unregister_device(tp);
 	if (ts)
 		i2c_unregister_device(ts);
+
+	platform_device_unregister(cros_platform_device);
+	platform_driver_unregister(&cros_platform_driver);
 }
 
 module_init(chromeos_laptop_init);

