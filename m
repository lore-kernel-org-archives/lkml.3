Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaECFII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 01:08:08 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58765 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaECFIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 01:08:06 -0400
Message-ID: <536479AD.9040104@gmail.com>
Date: Sat, 03 May 2014 13:07:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>, a.zummo@towertech.it,
        sangjung.woo@samsung.com
CC: rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug()
 for typo issue
References: <53647962.6070006@gmail.com>
In-Reply-To: <53647962.6070006@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only a typo issue, the related commit:

  "1fbc4c4 drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()"

The related error (unicore32 with allmodconfig):

    CC [M]  drivers/rtc/rtc-puv3.o
  drivers/rtc/rtc-puv3.c: In function ‘puv3_rtc_setpie’:
  drivers/rtc/rtc-puv3.c:74: error: implicit declaration of function ‘dev_debug’


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/rtc/rtc-puv3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 1ecfe3b..c56310e 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -71,7 +71,7 @@ static int puv3_rtc_setpie(struct device *dev, int enabled)
 {
 	unsigned int tmp;
 
-	dev_debug(dev, "%s: pie=%d\n", __func__, enabled);
+	dev_dbg(dev, "%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&puv3_rtc_pie_lock);
 	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
-- 
1.9.2.459.g68773ac
