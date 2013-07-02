Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3GBRSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:18:25 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:37859 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3GBRSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:18:24 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 3/3] rtc: ds1742: Report to RTC core if retrieved time is invalid
Date: Tue,  2 Jul 2013 20:50:02 +0400
Message-Id: <1372783802-6569-3-git-send-email-shc_work@mail.ru>
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
 drivers/rtc/rtc-ds1742.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 139934f..17b73fd 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -115,11 +115,7 @@ static int ds1742_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	/* year is 1900 + tm->tm_year */
 	tm->tm_year = bcd2bin(year) + bcd2bin(century) * 100 - 1900;
 
-	if (rtc_valid_tm(tm) < 0) {
-		dev_err(dev, "retrieved date/time is not valid.\n");
-		rtc_time_to_tm(0, tm);
-	}
-	return 0;
+	return rtc_valid_tm(tm);
 }
 
 static const struct rtc_class_ops ds1742_rtc_ops = {
-- 
1.8.1.5

