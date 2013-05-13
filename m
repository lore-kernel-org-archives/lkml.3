Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3EMG0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:26:04 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:57267 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3EMG0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:26:01 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 14:26:00 +0800
Message-ID: <CAPgLHd-+10_c9A64OW8QkjgGn+FjrpMQTH+C+Y-HN_fwgQSrKA@mail.gmail.com>
Subject: [PATCH] rtc: rtc-vr41xx: fix error return code in rtc_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.zummo@towertech.it, akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -EBUSY in the platform irq get error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/rtc/rtc-vr41xx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 3b5b4fa..54e104e 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -339,8 +339,10 @@ static int rtc_probe(struct platform_device *pdev)
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq <= 0)
+	if (pie_irq <= 0) {
+		retval = -EBUSY;
 		goto err_free_irq;
+	}
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
 			     "rtclong1", pdev);

