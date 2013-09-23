Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3IWJjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:39:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28344 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3IWJjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:39:39 -0400
X-AuditID: cbfee68e-b7f756d000004512-78-52400c5a1751
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 01/15] rtc: rtc-88pm80x: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:39:38 +0900
Message-id: <001d01ceb840$d2036a60$760a3f20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAABDUA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI90oHocgg2n7BSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2Lt3B0vBap6Kgyu+MDcwruLqYuTkkBAwkfi9fDorhC0mceHeerYuRi4OIYFljBIf
	puxhgil682APC0RiOqNE69LHTBDOL0aJFXvusoBUsQmoSXz5cpi9i5GDQ0RAX6KtRQOkhlmg
	l1HiTO9udpAaIQFbiYnTvoJN5RSwk1jzeRkTSL2wgL3E7e11IGEWAVWJ76sawEbyApXvOvqY
	CcIWlPgx+R5YnFlAS2LztiZWCFteYvOat8wgYyQE1CUe/dUFCYsIGEmsu/QdqlxEYt+Ld4wg
	50gIPGKXOPjwKQvELgGJb5MPsUD0ykpsOsAM8a+kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJG
	llWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIZHat4Px5gHrQ4zJQOsnMkuJJucDIz2vJN7Q
	2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwGwleu5XDt
	7LWVL1pz3OLkzWUb8+PjHPJ+8/LEW9eaZ+75UVV/64BCv+KMzA9LOsoFDn9e5ul5zXBv/yvG
	h+ZevEu+3Xsp7Fdpp/B3iePkvlZpHk6fhuiJj3s3vmh//uxHQeD/fzsC37+JM9pQcuCGof0/
	83Nqi5xtHr5OTORN/imtt2TltUlKLMUZiYZazEXFiQDIVFdV6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd0oHocgg2/3eCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNi7dwdLwWqeioMrvjA3MK7i6mLk5JAQMJF4
	82APC4QtJnHh3nq2LkYuDiGB6YwSrUsfM0E4vxglVuy5C1bFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBGwlJk77ygRicwrYSaz5vIwJpF5YwF7i9vY6kDCLgKrE91UNYCN5
	gcp3HX3MBGELSvyYfA8sziygJbF5WxMrhC0vsXnNW2aQMRIC6hKP/uqChEUEjCTWXfoOVS4i
	se/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOA08
	k9rBuLLB4hCjAAejEg9vRKJ9kBBrYllxZe4hRgkOZiURXj9WhyAh3pTEyqrUovz4otKc1OJD
	jMlAj05klhJNzgemqLySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi
	4JRqYJyYcOCLmfGnEye2/Jt14v6TwEPxBk9X5e47yKrYb9t35kRX6roCTlvWg7MkV8TG/Dz6
	Zp6v9cRrF+8v/X7micsEsSm3kkyO39s3f9qKTIXMH4+SXktNislg917hXXqYuerfrznm0o92
	2LVfYbbwqNjPILelX/Oc5cSFk6VqvvLUZS/a6GIsMEdXiaU4I9FQi7moOBEAV8kkAEcDAAA=
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
 drivers/rtc/rtc-88pm80x.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 354c937..0916089 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -251,14 +251,15 @@ static SIMPLE_DEV_PM_OPS(pm80x_rtc_pm_ops, pm80x_rtc_suspend, pm80x_rtc_resume);
 static int pm80x_rtc_probe(struct platform_device *pdev)
 {
 	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm80x_platform_data *pm80x_pdata;
+	struct pm80x_platform_data *pm80x_pdata =
+				dev_get_platdata(pdev->dev.parent);
 	struct pm80x_rtc_pdata *pdata = NULL;
 	struct pm80x_rtc_info *info;
 	struct rtc_time tm;
 	unsigned long ticks = 0;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (pdata == NULL)
 		dev_warn(&pdev->dev, "No platform data!\n");
 
@@ -326,8 +327,7 @@ static int pm80x_rtc_probe(struct platform_device *pdev)
 	regmap_update_bits(info->map, PM800_RTC_CONTROL, PM800_RTC1_USE_XO,
 			   PM800_RTC1_USE_XO);
 
-	if (pdev->dev.parent->platform_data) {
-		pm80x_pdata = pdev->dev.parent->platform_data;
+	if (pm80x_pdata) {
 		pdata = pm80x_pdata->rtc;
 		if (pdata)
 			info->rtc_dev->dev.platform_data = &pdata->rtc_wakeup;
-- 
1.7.10.4


