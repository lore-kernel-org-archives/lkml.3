Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3C1Ih3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:37:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14645 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3C1IhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:37:22 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-92-5154014048e2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
In-reply-to: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
Subject: [PATCH 2/8] rtc: rtc-bfin: convert bfin_rtc_driver to dev_pm_ops
Date: Thu, 28 Mar 2013 17:37:20 +0900
Message-id: <001101ce2b8f$764145f0$62c3d1d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOwAAAf0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY10HxpBAg3NLDSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOLRQo+Aeb8Wxx7OZGhgXc3cxcnJICJhIzOnvZIWwxSQu3FvP1sXIxSEksIxR4tXc
	qSxdjBxgRUf+lUHEpzNKrGlfyATh/GKUOP9xClg3m4CaxJcvh9lBGkQE9CXaWjRAapgFehkl
	zvTuZgepERKwlTh3+CoziM0pYCfRvmYrC4gtLOApMeHYAUYQm0VAVeL1lP1sIDYvUP3PM9dY
	IGxBiR+T74HZzAJaEut3HmeCsOUlNq95ywxxqLrEo7+6IGERASOJDQd+QpWISOx78Y4R4sl7
	7BIft5VArBKQ+Db5ENSPshKbDjBDlEhKHFxxg2UCo8QsJItnIVk8C8niWUg2LGBkWcUomlqQ
	XFCclF5kqlecmFtcmpeul5yfu4kREqUTdzDeP2B9iDEZaP1EZinR5HxglOeVxBsamxlZmJqY
	GhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVF7j11k1PTnTCrZU2ui
	99k8vma2iZPZm/ERyy3+Z/JvV212mGTxfvJxXm7tjkNZxnzF0qL9p3nuhBj3bueuDrpntSJ5
	n9Tb11v/sr7Jrnsa9fSVstKixQ+fXPiVlJin9Kzm4IakV1q7ttw9sKpc3LWTJcZ5luPF1Yv3
	/Ox6el1KJp3jwL1AFVYlluKMREMt5qLiRAB+jPeB6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV0HxpBAg329OhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZhxaqFFwj7fi2OPZTA2Mi7m7GDk4JARMJI78
	K+ti5AQyxSQu3FvP1sXIxSEkMJ1RYk37QiYI5xejxPmPU1hBqtgE1CS+fDnMDtIsIqAv0dai
	AVLDLNDLKHGmdzc7SI2QgK3EucNXmUFsTgE7ifY1W1lAbGEBT4kJxw4wgtgsAqoSr6fsZwOx
	eYHqf565xgJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiKPVJR791QUJiwgYSWw48BOqRERi
	34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwEngm
	tYNxZYPFIUYBDkYlHt4KgeBAIdbEsuLK3EOMEhzMSiK8hzqBQrwpiZVVqUX58UWlOanFhxiT
	gR6dyCwlmpwPTFB5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp
	1cAYk6mhPCfy65ZlS5OSmjaqip2Yd+v0/n9HS14+6v+9If3g4jvOsx3uNW/KbJuYOmnqvTdm
	k1ab6kvMWpTBLZaoqxkXoe66XNPs8/05Vg/qGad19R+7FZB3JUbkMi/v5voX1f1rbV+YVr24
	rsAgbKjw/oJH85rbS6YLb55o4qtQvNMtKeZvlPxmJZbijERDLeai4kQApJ8sEkYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-bfin.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 4ec614b..f35b17a 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -402,11 +402,9 @@ static int bfin_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int bfin_rtc_suspend(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-
 	dev_dbg_stamp(dev);
 
 	if (device_may_wakeup(dev)) {
@@ -418,10 +416,8 @@ static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int bfin_rtc_resume(struct platform_device *pdev)
+static int bfin_rtc_resume(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-
 	dev_dbg_stamp(dev);
 
 	if (device_may_wakeup(dev))
@@ -440,20 +436,18 @@ static int bfin_rtc_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#else
-# define bfin_rtc_suspend NULL
-# define bfin_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(bfin_rtc_pm_ops, bfin_rtc_suspend, bfin_rtc_resume);
+
 static struct platform_driver bfin_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-bfin",
 		.owner	= THIS_MODULE,
+		.pm	= &bfin_rtc_pm_ops,
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= bfin_rtc_remove,
-	.suspend	= bfin_rtc_suspend,
-	.resume		= bfin_rtc_resume,
 };
 
 module_platform_driver(bfin_rtc_driver);
-- 
1.7.2.5


