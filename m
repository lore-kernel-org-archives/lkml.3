Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935532Ab3BOH23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:28:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58341 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOH22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:28:28 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-62-511de39ac4c7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 06/11] rtc: rtc-at91rm9200: use dev_dbg()/dev_err() instead
 of printk()/pr_debug()
Date: Fri, 15 Feb 2013 16:28:26 +0900
Message-id: <003001ce0b4e$0b533480$21f99d80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAGwCg
Content-language: ko
x-cr-hashedpuzzle: BBnl C/IO DG51 Ibti I3y6 O2qK QaBX RcBC d4d6 f6Yi kxzc lZL6
 ng8U rMD7 tVcB
 uIRq;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{4C2A983A-FE5A-4E4D-9FBC-AFA31AF592A0};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 15 Feb 2013 07:28:19
 GMT;WwBQAEEAVABDAEgAIABWADMAIAAwADYALwAxADEAXQAgAHIAdABjADoAIAByAHQAYwAtAGEAdAA5ADEAcgBtADkAMgAwADAAOgAgAHUAcwBlACAAZABlAHYAXwBkAGIAZwAoACkALwBkAGUAdgBfAGUAcgByACgAKQAgAGkAbgBzAHQAZQBhAGQAIABvAGYAIABwAHIAaQBuAHQAawAoACkALwBwAHIAXwBkAGUAYgB1AGcAKAApAA==
x-cr-puzzleid: {4C2A983A-FE5A-4E4D-9FBC-AFA31AF592A0}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zfd1Zj2UDDdr3mVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MhsfTmAsmSFX8PH6KqYHxkmgXIyeHhICJxI3t91kgbDGJC/fW
	s3UxcnEICSxjlNj7YgIzTNGKE3cZIRKLGCV67/xggXBmM0m8njydEaSKTUBN4suXw+xdjBwc
	IgL6Em0tGiA1zAK9jBJnenezg9QICdhKTP39jRXE5hSwk1g9qQOsXlggXeJmnydImEVAVeLS
	qglg5bxA5b+ndjJB2IISPybfA7uUWUBLYvO2JlYIW15i85q3zCBjJATUJR791QUJiwgYSSzp
	PAdVIiKx78U7RohftrBJ9G6JhrBNJc5+usIEcqaEwC52idt9vawQNwhIfJt8iAVipqzEpgPQ
	cJCUOLjiBssERqlZSC6aheSiWUgumoVk9QJGllWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsY
	IZHYu4Px9gHrQ4zJQOsnMkuJJucDIzmvJN7Q2NjEzMTUxNzS1NyUNGElcV65SzKBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhhD18Ys0OdySD/SLba94qtD+EmHynqHf+41dVLhGevED9xx
	Vzx8b8rpD7+PMd2e+GoV08mtTVuXXuovUJkxl0dC8VisjDvTTAG77BC3X4YPV645EDjbdOou
	eT2mNgG3/XMrmra1GDx7tHju80NrxNfkbbh/8tSrEFfhGT7xD3dyNN62X+DvGaCixFKckWio
	xVxUnAgA0jNtAtoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd1Zj2UDDU71G1hc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjIbH05gLJkhV/Dx+iqmB
	8ZJoFyMnh4SAicSKE3cZIWwxiQv31rN1MXJxCAksYpTovfODBcKZzSTxevJ0sCo2ATWJL18O
	s3cxcnCICOhLtLVogNQwC/QySpzp3c0OUiMkYCsx9fc3VhCbU8BOYvWkDrB6YYF0iZt9niBh
	FgFViUurJoCV8wKV/57ayQRhC0r8mHyPBcRmFtCS2LytiRXClpfYvOYtM8gYCQF1iUd/dUHC
	IgJGEks6z0GViEjse/EO6pctbBK9W6IhbFOJs5+uME1gFJmFZMMsJBtmIdkwC8moBYwsqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4/yZ9A7GVQ0WhxgFOBiVeHgFJGQDhVgTy4orcw8x
	SnAwK4nwyt0CCvGmJFZWpRblxxeV5qQWH2JMBgbARGYp0eR8YArKK4k3NDYxM7I0MrMwMjE3
	J01YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2MyRLHmGV6reUueOlMOj850KirftvPVzmT
	21Wuel6fkeS80fmVBbe05NZ2weiNsbvyniyti86XUmCPXvVi0qyfgXfK3mrq7EtorKtj5Kjw
	s5g6l/1bPZffljPWodx3djRr6HD0cTIdtGK/7Cg35xYLW2Tr3s2BV9bedb2Td+XJj49qJ2+Y
	hLAosRRnJBpqMRcVJwIAqBt6AjcDAAA=
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

Changes since v2:
- Remove redundant prefix

 drivers/rtc/rtc-at91rm9200.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index b6469e2..434ebc3 100644
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
+		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
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


