Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3IWJsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:48:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57055 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab3IWJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:48:10 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-fd-52400e5936d6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 10/15] rtc: rtc-m48t59: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:48:08 +0900
Message-id: <002601ceb842$028dc1c0$07a94540$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAVNLg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY91IPocggwfzOCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmHGim62gVb1iQu9StgbGaYpdjJwcEgImEvMOr2KDsMUkLtxbD2RzcQgJLGOUmDO1
	jQ2m6PHdG1CJRYwSd5sbmSCcX4wS8/c2MYFUsQmoSXz5cpi9i5GDQ0RAX6KtRQOkhlmgl1Hi
	TO9udpAaIQFbiYnTvoLVcwrYSaz5vIwJpF4YyN463xUkzCKgKrFx+1WwEl6g8lcXl0LZghI/
	Jt9jAbGZBbQkNm9rYoWw5SU2r3nLDDJGQkBd4tFfXZCwiICRxObOiYwQJSIS+168YwQ5R0Lg
	HrvE1dOv2SF2CUh8m3yIBaJXVmLTAWaIfyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y1StOzC0uzUvXS87P3cQIidSJOxjvH7A+xJgMtH4is5Rocj4w0vNK4g2NzYws
	TE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJiz5XTwoZD3nzoa
	N4jH3D2/fMnq7Ttu7zF5u7nj4lz5850SnJKr373MWf8/KSLNkO+wX433kz/VsiWdjyq91R9c
	l7E7FBFSxhlYkhB9e8/TsLaiisuzv3ns8Cl8OYfJm39HQbqio68jx8eJOTs18rPWrPh4VWzZ
	mw+irydmhvxe1TAngpstarESS3FGoqEWc1FxIgBwHxc86gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1IPocggy/9zBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZsw40c1W0KpeMaF3KVsD4zTFLkZODgkBE4nH
	d2+wQdhiEhfurQeyuTiEBBYxStxtbmSCcH4xSszf28QEUsUmoCbx5cth9i5GDg4RAX2JthYN
	kBpmgV5GiTO9u9lBaoQEbCUmTvsKVs8pYCex5vMyJpB6YSB763xXkDCLgKrExu1XwUp4gcpf
	XVwKZQtK/Jh8jwXEZhbQkti8rYkVwpaX2LzmLTPIGAkBdYlHf3VBwiICRhKbOycyQpSISOx7
	8Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4Dz6R3
	MK5qsDjEKMDBqMTDG5loHyTEmlhWXJl7iFGCg1lJhNeP1SFIiDclsbIqtSg/vqg0J7X4EGMy
	0KMTmaVEk/OBKSqvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODil
	GhitDCVWBPdcXanHLuLrvnP6S+e/2rsc/nl9mZ//csu5qmTuC/N9ROsq5bu7JdVjHqdYtzTs
	mOp/u+Z2W66vWtL3ZSyaXhWaVoL1TDYd/NPFLx65brZo/qVHf2KiJr9krrs/45vWPLaWdXbt
	lRyX9mzYc2DphZj9X5Kmtc6wVuOYLPb1vEW4b4ASS3FGoqEWc1FxIgD4YSSPRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-m48t59.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index fcb0329..11880c1 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -68,7 +68,7 @@ m48t59_mem_readb(struct device *dev, u32 ofs)
 static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val;
@@ -111,7 +111,7 @@ static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val = 0;
@@ -158,7 +158,7 @@ static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
 static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	unsigned long flags;
@@ -205,7 +205,7 @@ static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	u8 mday, hour, min, sec;
@@ -266,7 +266,7 @@ static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int m48t59_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 
@@ -283,7 +283,7 @@ static int m48t59_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static int m48t59_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val;
@@ -304,7 +304,7 @@ static irqreturn_t m48t59_rtc_interrupt(int irq, void *dev_id)
 {
 	struct device *dev = (struct device *)dev_id;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	u8 event;
 
@@ -340,7 +340,7 @@ static ssize_t m48t59_nvram_read(struct file *filp, struct kobject *kobj,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	ssize_t cnt = 0;
 	unsigned long flags;
@@ -360,7 +360,7 @@ static ssize_t m48t59_nvram_write(struct file *filp, struct kobject *kobj,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	ssize_t cnt = 0;
 	unsigned long flags;
@@ -385,7 +385,7 @@ static struct bin_attribute m48t59_nvram_attr = {
 
 static int m48t59_rtc_probe(struct platform_device *pdev)
 {
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = NULL;
 	struct resource *res;
 	int ret = -ENOMEM;
-- 
1.7.10.4


