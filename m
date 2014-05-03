Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbaECFJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 01:09:14 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:41539 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaECFJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 01:09:13 -0400
Message-ID: <536479EE.4090500@gmail.com>
Date: Sat, 03 May 2014 13:09:02 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>, a.zummo@towertech.it,
        sangjung.woo@samsung.com
CC: rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue
 MIME-Version: 1.0
References: <53647962.6070006@gmail.com>
In-Reply-To: <53647962.6070006@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only a typo issue, the related commit:

  "1fbc4c4 drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()"

The related error (for unicore32 with allmodconfig):

    CC [M]  drivers/rtc/rtc-puv3.o
  drivers/rtc/rtc-puv3.c: In function ‘puv3_rtc_setalarm’:
  drivers/rtc/rtc-puv3.c:143: error: ‘struct device’ has no member named ‘dev’


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/rtc/rtc-puv3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index c56310e..1cff2a2 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -140,7 +140,7 @@ static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	rtc_tm_to_time(tm, &rtcalarm_count);
 	writel(rtcalarm_count, RTC_RTAR);
 
-	puv3_rtc_setaie(&dev->dev, alrm->enabled);
+	puv3_rtc_setaie(dev, alrm->enabled);
 
 	if (alrm->enabled)
 		enable_irq_wake(puv3_rtc_alarmno);
-- 
1.9.2.459.g68773ac
