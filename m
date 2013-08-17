Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3HQGof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 02:44:35 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:52692 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3HQGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 02:44:34 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH RESEND 2/3] rtc: ds1742: Remove unused field "rtc" from private structure
Date: Sat, 17 Aug 2013 10:43:55 +0400
Message-Id: <1376721836-27153-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376721836-27153-1-git-send-email-shc_work@mail.ru>
References: <1376721836-27153-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Private field "rtc" is not used outside "probe", so there are
no reason to keep it in driver.

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

