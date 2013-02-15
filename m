Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161204Ab3BOGq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:46:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52822 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161111Ab3BOGq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:46:26 -0500
X-AuditID: cbfee68f-b7f656d000000d78-74-511dd9bd1890
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 06/11] rtc: rtc-at91rm9200: use dev_dbg()/dev_err() instead
 of printk()/pr_debug()
Date: Fri, 15 Feb 2013 15:46:21 +0900
Message-id: <002401ce0b48$2a103860$7e30a920$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAAH1cg
Content-language: ko
x-cr-hashedpuzzle: ClY= CwVk JZTF QIP+ Sm81 St78 XjhF i8Bv jLCA pVRZ sSRl tusA
 uSfD u+h3 wKwf
 y/tu;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{6903DA45-DE89-475E-8A70-47908C97F57C};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 15 Feb 2013 06:46:13
 GMT;WwBQAEEAVABDAEgAIABWADIAIAAwADYALwAxADEAXQAgAHIAdABjADoAIAByAHQAYwAtAGEAdAA5ADEAcgBtADkAMgAwADAAOgAgAHUAcwBlACAAZABlAHYAXwBkAGIAZwAoACkALwBkAGUAdgBfAGUAcgByACgAKQAgAGkAbgBzAHQAZQBhAGQAIABvAGYAIABwAHIAaQBuAHQAawAoACkALwBwAHIAXwBkAGUAYgB1AGcAKAApAA==
x-cr-puzzleid: {6903DA45-DE89-475E-8A70-47908C97F57C}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zY929N2UDDdY+ELO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZj+eyFbySrDjWoN/AuE20i5GTQ0LAROLMqaVsELaYxIV768Fs
	IYFljBJfPovD1HyYOJe1i5ELKD6dUeL28tssEM5sJom7LfuZQKrYBNQkvnw5zN7FyMEhIqAv
	0daiAVLDLNDLKHGmdzdYXEjAVmLqbWcQk1PATuL9dFOQTmGBdIk9D66C7WURUJVYf/stO4jN
	C1S95+hWJghbUOLH5HssIDazgJbE5m1NrBC2vMTmNW+ZQUZKCKhLPPqrC3GAkcSOt+UQFSIS
	+168YwQ5RkJgC5tE5/yDjBBvmUoc3byKGSKxi13i+voTTBA3CEh8m3yIBWKmrMSmA8wQ9ZIS
	B1fcYJnAKDULyUWzkFw0C8lFs5DsXsDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJAL7
	dzDePWB9iDEZaP1EZinR5HxgBOeVxBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUAyOvbXy+zwudaV8KlW5InJhQcMKp67/6OtGT3ntnmTBP03g1q4Qh
	4uixTqNd09qdfgt9vnzKoD/w87mo6ObUiNP/Nv/TEXpqGTNhp+CbLvE81p+ehXP/B1UGZYsa
	Jn41Mt5wwJTn/Mm2bpEtPctnFLKmMEd8UHGcWOL7/uw/z1qmyaldd/aeOaHEUpyRaKjFXFSc
	CADpD5Lk1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd29N2UDDRZ9FbK4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGY/nshW8kqw41qDfwLhN
	tIuRk0NCwETiw8S5rBC2mMSFe+vZuhi5OIQEpjNK3F5+mwXCmc0kcbdlPxNIFZuAmsSXL4fZ
	uxg5OEQE9CXaWjRAapgFehklzvTuBosLCdhKTL3tDGJyCthJvJ9uCtIpLJAusefBVTYQm0VA
	VWL97bfsIDYvUPWeo1uZIGxBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGUGGSkhoC7x6K8uxAFG
	EjvelkNUiEjse/GOEeQYCYEtbBKd8w8yQrxlKnF08yrmCYwis5BsmIVkwywkG2YhmbWAkWUV
	o2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCEP5PawbiyweIQowAHoxIPr4CEbKAQa2JZcWXu
	IUYJDmYlEd41IUAh3pTEyqrUovz4otKc1OJDjMnAAJjILCWanA9MPnkl8YbGJmZGlkZmFkYm
	5uakCSuJ8zKeehIgJJCeWJKanZpakFoEs4WJg1OqgZFhskz2eUdH6QsrpdrYEpqkT3WE3D17
	LKFO7+A6q+T8nVnxuaobfbIOzI05MC9zienaHx0csk84y309Q3au0zDu5+J2VtH8mfSkcm9D
	t9yHjk+xXmk/JvJJfz2c/sFjtezzrfM2GZd+SfC8/stki5G2eeBPxneH5LYuDErPSRQ8e9H+
	/LoTC5RYijMSDbWYi4oTAcbRQPc0AwAA
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
No changes since v1:

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


