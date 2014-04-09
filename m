Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbaDIQiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:38:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55013 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIQiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:38:03 -0400
From: Chris Cui <chris.wei.cui@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Chris Cui <chris.wei.cui@gmail.com>
Subject: [PATCH] rtc: fix pcf8523 bug in month definition.
Date: Thu, 10 Apr 2014 00:34:49 +0800
Message-Id: <1397061289-22334-1-git-send-email-chris.wei.cui@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCF8523 uses 1-12 to represent month according to datasheet. 
link: www.nxp.com/documents/data_sheet/PCF8523.pdf

Signed-off-by: Chris Cui <chris.wei.cui@gmail.com>
---
 drivers/rtc/rtc-pcf8523.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
index 5c8f822..56796a7 100644
--- a/drivers/rtc/rtc-pcf8523.c
+++ b/drivers/rtc/rtc-pcf8523.c
@@ -204,7 +204,7 @@ static int pcf8523_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	tm->tm_sec = bcd2bin(regs[0] & 0x7f);
 	tm->tm_min = bcd2bin(regs[1] & 0x7f);
 	tm->tm_hour = bcd2bin(regs[2] & 0x3f);
-	tm->tm_mday = bcd2bin(regs[3] & 0x3f);
+	tm->tm_mday = bcd2bin(regs[3] & 0x3f) - 1;
 	tm->tm_wday = regs[4] & 0x7;
 	tm->tm_mon = bcd2bin(regs[5] & 0x1f);
 	tm->tm_year = bcd2bin(regs[6]) + 100;
@@ -229,7 +229,7 @@ static int pcf8523_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	regs[3] = bin2bcd(tm->tm_hour);
 	regs[4] = bin2bcd(tm->tm_mday);
 	regs[5] = tm->tm_wday;
-	regs[6] = bin2bcd(tm->tm_mon);
+	regs[6] = bin2bcd(tm->tm_mon + 1);
 	regs[7] = bin2bcd(tm->tm_year - 100);
 
 	msg.addr = client->addr;
-- 
1.8.3.2

