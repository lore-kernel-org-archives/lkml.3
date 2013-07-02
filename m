Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3GBQuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:50:40 -0400
Received: from fallback7.mail.ru ([94.100.176.135]:45972 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3GBQuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:50:39 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/3] rtc: ds1742: Remove unused field "rtc" from private structure
Date: Tue,  2 Jul 2013 20:50:01 +0400
Message-Id: <1372783802-6569-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372783802-6569-1-git-send-email-shc_work@mail.ru>
References: <1372783802-6569-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/rtc/rtc-ds1742.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 9fba0ae..139934f 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -52,7 +52,6 @@
 #define RTC_BATT_FLAG		0x80
 
 struct rtc_plat_data {
-	struct rtc_device *rtc;
 	void __iomem *ioaddr_nvram;
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
@@ -206,7 +205,6 @@ static int ds1742_rtc_probe(struct platform_device *pdev)
 				  &ds1742_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
-	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 
-- 
1.8.1.5

