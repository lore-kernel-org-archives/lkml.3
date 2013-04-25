Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3DYJeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:34:04 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:64548 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3DYJeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:34:02 -0400
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 17:34:00 +0800
Message-ID: <CAPgLHd-LgvQ_rka+tFHxufUThBZ6z6q1g8Cp8GKcyYa=Dp5-ZQ@mail.gmail.com>
Subject: [PATCH -next] rtc: rtc-pcf2123: fix error return code in pcf2123_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.zummo@towertech.it, akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENODEV in the chip not found error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/rtc/rtc-pcf2123.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 6a3f329..796a6c5 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -266,6 +266,7 @@ static int pcf2123_probe(struct spi_device *spi)
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "chip not found\n");
+		ret = -ENODEV;
 		goto kfree_exit;
 	}
 

