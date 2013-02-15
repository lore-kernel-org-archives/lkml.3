Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355Ab3BOGAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:00:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25850 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3BOGAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:00:43 -0500
X-AuditID: cbfee690-b7f066d00000169f-aa-511dcf09d6d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 06/11] rtc: rtc-at91rm9200: use dev_dbg()/dev_err() instead of
 printk()/pr_debug()
Date: Fri, 15 Feb 2013 15:00:41 +0900
Message-id: <001701ce0b41$c9372fe0$5ba58fa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAGtCg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY13O87KBBvOf2lhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MYyf72AsuSVac/LSQqYFxqWgXIyeHhICJxOLWC0wQtpjEhXvr
	2UBsIYFljBJtD1S7GDnAal4+EO5i5AIKL2KUmPdoLROEM5tJ4sKGZ2DNbAJqEl++HGYHaRAR
	0Jdoa9EAqWEW6GWUONO7mx1iqK3EhE/rmEFsTgE7ie9/HoItExZIkTjZ3cYE0ssioCqxrUMX
	JMwLVL7h21ZGCFtQ4sfkeywgNrOAlsTmbU2sELa8xOY1b5kh7lSXePQXrFVEwEhi3d7bUOUi
	EvtevGMEOUdCYBm7xKJDL8HOYREQkPg2+RALRK+sxKYDzJBgkJQ4uOIGywRGiVlINs9CsnkW
	ks2zkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkqibsYLx3wPoQYzLQ+onMUqLJ
	+cCozCuJNzQ2NjEzMTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	Rm19I2eJmJgJ0udvTV5WFsPssaU2v+Nu4Mreu5GXIjourw35kbJW99fU48v+XchX3r/hlO/z
	upxfHzqPveDMrGR1bU85WvVGPvhUo5f94XVXTxhE/n8i8Xrjjt9PXzzd43vx+u/wHfu6Eo3S
	pwq0fRBaY/28f1lMrta7Ox+Nns+c1PL4tdxC81lKLMUZiYZazEXFiQBYZOdMwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgC7nedlAg/bfZhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49jJPvaCS5IVJz8tZGpg
	XCraxcjBISFgIvHygXAXIyeQKSZx4d56ti5GLg4hgUWMEvMerWWCcGYzSVzY8IwJpIpNQE3i
	y5fD7CDNIgL6Em0tGiA1zAK9jBJnenezg9QICdhKTPi0jhnE5hSwk/j+5yEbiC0skCJxsruN
	CaSXRUBVYluHLkiYF6h8w7etjBC2oMSPyfdYQGxmAS2JzduaWCFseYnNa94yQ9ysLvHoL1ir
	iICRxLq9t6HKRST2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgRH7TOpHYwrGywOMQpwMCrx8ApIyAYKsSaWFVfmHmKU4GBWEuFdEwIU4k1JrKxK
	LcqPLyrNSS0+xJgM9OdEZinR5HxgQskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU
	7NTUgtQimC1MHJxSDYyS3B7pFe+PLcx5+eyDgdQy54aO/TfnR2lqh8oXv86fYd56yrUnLYr5
	9Zxzuy5zxupL7+o+uqSKe2Hz7g6ht/fe/O7ZEpzidFCa/0hEatmCAzcXr54btbj4yEunZ6/E
	t+/75a6wIi321rJmZ4UD99+eXzVV3+jw/i/sXx/pus9TsNsorpMguj1LiaU4I9FQi7moOBEA
	Sv4LkB4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-at91rm9200.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index b6469e2..4a2e451 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -86,7 +86,7 @@ static int at91_rtc_readtime(struct device *dev, struct rtc_time *tm)
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = tm->tm_year - 1900;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -100,7 +100,7 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 {
 	unsigned long cr;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -145,7 +145,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
 			? 1 : 0;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -183,7 +183,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
 	}
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		at91_alarm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour,
 		tm.tm_min, tm.tm_sec);
 
@@ -192,7 +192,7 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
-	pr_debug("%s(): cmd=%08x\n", __func__, enabled);
+	dev_dbg(dev, "%s(): cmd=%08x\n", __func__, enabled);
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
@@ -240,7 +240,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 
 		rtc_update_irq(rtc, 1, events);
 
-		pr_debug("%s(): num=%ld, events=0x%02lx\n", __func__,
+		dev_dbg(&pdev->dev, "%s(): num=%ld, events=0x%02lx\n", __func__,
 			events >> 8, events & 0x000000FF);
 
 		return IRQ_HANDLED;
@@ -296,8 +296,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 				IRQF_SHARED,
 				"at91_rtc", pdev);
 	if (ret) {
-		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
-				irq);
+		dev_err(&pdev->dev, "at91_rtc: IRQ %d already in use.\n", irq);
 		return ret;
 	}
 
@@ -315,7 +314,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, rtc);
 
-	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
+	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
 
-- 
1.7.2.5


