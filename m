Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3IWJsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:48:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17397 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IWJsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:48:46 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-c5-52400e7d3a93
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 11/15] rtc: rtc-m48t86: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:48:45 +0900
Message-id: <002701ceb842$18401bd0$48c05370$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAW4Pg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ91aPocgg9VnZS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2NadXnCGr2LXmh3MDYzTeLoYOTkkBEwkvjz9yQphi0lcuLeerYuRi0NIYBmjxOFJ
	a5hhij682MoMkVjEKPHlwXKoql+MEtMn72AHqWITUJP48uUwkM3BISKgL9HWogFSwyzQyyhx
	pnc3WI2QgK3ExGlfmUBsTgE7iTWfl4HZwkD248v32EBsFgFVifmP34HV8wLVN735BWULSvyY
	fI8FxGYW0JLYvK2JFcKWl9i85i0zyF4JAXWJR391QcIiAkYSZyfsYIIoEZHY9+IdI8g9EgK3
	2CUaN99lgtglIPFt8iEWiF5ZiU0HoB6WlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1
	ILmgOCm9yESvODG3uDQvXS85P3cTIyRSJ+xgvHfA+hBjMtD6icxSosn5wEjPK4k3NDYzsjA1
	MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjQh+dtSlsN8V5BUvf
	PA5K3i7XnOr4Y5Ow2hq2wM1lm0RLrttZR9RYbd7cUKm12ts+4HDT/H+vJHk0fb5lzdDetGOP
	jc7nLUmq9XYi5poT/xZxV/7OXdN/f/rb287ff58T+Dn/S5Dt7muaOUHRQdcMX58+1eZ5U7C7
	QtTVp3feW4VilkwxFXklluKMREMt5qLiRAAHKVdq6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1aPocggyW3JS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNjWnV5whq9i15odzA2M03i6GDk5JARMJD68
	2MoMYYtJXLi3nq2LkYtDSGARo8SXB8uhnF+MEtMn72AHqWITUJP48uUwkM3BISKgL9HWogFS
	wyzQyyhxpnc3WI2QgK3ExGlfmUBsTgE7iTWfl4HZwkD248v32EBsFgFVifmP34HV8wLVN735
	BWULSvyYfI8FxGYW0JLYvK2JFcKWl9i85i0zyF4JAXWJR391QcIiAkYSZyfsYIIoEZHY9+Id
	4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcBp5J72Bc
	1WBxiFGAg1GJhzcy0T5IiDWxrLgy9xCjBAezkgivH6tDkBBvSmJlVWpRfnxRaU5q8SHGZKBH
	JzJLiSbnA1NUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	FklNZxaPLqtadW1bnOcWgTUx7SEyJn+87X6l7UksNG/w1Q2fY9YcuOPj4u/b36xoqyyykg2K
	7HKvjdNmrxVc9NSr+pT2ZqeMZbGprbejXaJMJ6xeuj5MZdfTv9cP6P84fOmd1VUOW9fYP/GJ
	TF/Mtwh1FpWpVez5EXr6xvzZvxMaG/ZtnHpEiaU4I9FQi7moOBEAmCfwSUcDAAA=
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
 drivers/rtc/rtc-m48t86.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-m48t86.c b/drivers/rtc/rtc-m48t86.c
index 2d30314..32f64c9 100644
--- a/drivers/rtc/rtc-m48t86.c
+++ b/drivers/rtc/rtc-m48t86.c
@@ -46,7 +46,7 @@ static int m48t86_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -84,7 +84,7 @@ static int m48t86_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -123,7 +123,7 @@ static int m48t86_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -147,7 +147,7 @@ static const struct rtc_class_ops m48t86_rtc_ops = {
 static int m48t86_rtc_probe(struct platform_device *dev)
 {
 	unsigned char reg;
-	struct m48t86_ops *ops = dev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&dev->dev);
 	struct rtc_device *rtc;
 
 	rtc = devm_rtc_device_register(&dev->dev, "m48t86",
-- 
1.7.10.4


