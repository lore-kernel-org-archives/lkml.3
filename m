Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3CFFfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:35:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29401 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3CFFfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:35:11 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-22-5136d58d8e63
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 24/30] rtc: rtc-tegra: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:35:09 +0900
Message-id: <005a01ce1a2c$5dbf3ba0$193db2e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAARfUA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ93eq2aBBldnq1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0fXxL2tBF2fFvtZZLA2MJ9m7GDk4JARMJLYvs+1i5AQyxSQu3FvPBmILCSxjlJj/
	SB8ibiJxYv0Jpi5GLqD4dEaJJy/vMEM4vxglJi9ezwJSxSagJvHly2GwoSIC+hJtLRogNcwC
	vYwSZ3p3s0NMtZW42r2KGcTmFLCTWP54FlivsICrxLS/u5hAbBYBVYklK2+CzeEFql++MAYk
	zCsgKPFj8j2wcmYBLYn1O48zQdjyEpvXvGWG+EVd4tFfXZCwiICRxNnuNlaIEhGJfS/eMYKc
	IyHwiF3i0rwmZohVAhLfJh9igeiVldh0gBniX0mJgytusExglJiFZPMsJJtnIdk8C8mKBYws
	qxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCorRvB+PNA9aHGJOB1k9klhJNzgdGeV5JvKGx
	sYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM7sE5Iz7F7o
	x7PwhX/qofDSMM9WzYCPlUte2QSxT8lI1HczjdVinHzQ/2qU+MxTpncOMrC+6j2X7Goe4979
	Q/r4pW+HT6Z/O2/I/1eJY+d27mWWz1rzsw/8+7Um8L9t19Kpu+a2vK40zQ91fyF84kqc43r/
	DK7cpzqxBq5K12vOb3lbvCP4ixJLcUaioRZzUXEiALLG3QLoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd3eq2aBBt9nKlosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNH18S9rQRdnxb7WWSwNjCfZuxg5OSQETCRO
	rD/BBGGLSVy4t56ti5GLQ0hgOqPEk5d3mCGcX4wSkxevZwGpYhNQk/jy5TBQNweHiIC+RFuL
	BkgNs0Avo8SZ3t1gU4UEbCWudq9iBrE5Bewklj+eBdYrLOAqMe3vLrBtLAKqEktW3gSbwwtU
	v3xhDEiYV0BQ4sfke2DlzAJaEut3HmeCsOUlNq95ywxSLiGgLvHory5IWETASOJsdxsrRImI
	xL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4DTw
	TGoH48oGi0OMAhyMSjy8FkpmgUKsiWXFlbmHGCU4mJVEeLnOAIV4UxIrq1KL8uOLSnNSiw8x
	JgP9OZFZSjQ5H5ii8kriDY1NzIwsjcwsjEzMzUkTVhLnZTz1JEBIID2xJDU7NbUgtQhmCxMH
	p1QDY+qTDQHy/8VOzguta16640b2qpjYulPRb9KSfEu3+ynu+eGwy43nYNCXglkbtgbedz/5
	8z6XS1HarVjxyGWzju2KVV+RU/VXQuuw8LzV6RGnOl9eNBbqcX1QabLt4QH+YxsyRY56RB5a
	9vLAwysK0yeU9jj+fJ7zZZanaPXbo8Z/Fy8pCd1uXKbEUpyRaKjFXFScCAAC9XDzRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tegra.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 0020bab..7fbee55 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -348,7 +348,7 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register(
+	info->rtc_dev = devm_rtc_device_register(
 		pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
@@ -374,17 +374,11 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 err_dev_unreg:
-	rtc_device_unregister(info->rtc_dev);
-
 	return ret;
 }
 
 static int __exit tegra_rtc_remove(struct platform_device *pdev)
 {
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(info->rtc_dev);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


