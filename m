Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab3DAJqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:46:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58176 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab3DAJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:46:11 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-45-515957625ed2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 12/27] rtc: rtc-max8998: use devm_*() functions
Date: Mon, 01 Apr 2013 18:46:09 +0900
Message-id: <001701ce2ebd$bd469820$37d3c860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAIdbA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zfd2k8MhAgx0r+SyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKWHOqib3gCV/FisYHzA2Ms3i6GDk5JARMJP7Oa2KHsMUkLtxbzwZiCwksY5T4+5QD
	pmbf8k1ANVxA8UWMEtcnvWWFcH4xSpxa+ZMVpIpNQE3iy5fDQFUcHCIC+hJtLRogNcwCvYwS
	Z3p3s0NMtZX4cfY7M4jNKWAn8WbhPEYQW1jAXqLpxgmwGhYBVYnpPw8xgdi8QPX/W9+wQtiC
	Ej8m32MBsZkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJjodvmCFKRCT2vXjHCHKP
	hMAjdondj9ezQuwSkPg2+RALRK+sxKYDzBAPS0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZ
	xSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRESqf07GO8esD7EmAy0fiKzlGhyPjDS80riDY3N
	jCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOGHrlTLTOx/3
	Pdr1S+CIWIsE4+sIgY6X7R3l+0+5fe+18xDruLNt/yK51e3LWMOyjS4UT2bImvRf1323upiz
	kle9UfLBb7O2eK2Ld59eOOvxv0OK32c+CL6bpN9mWPR70aGFOg1TXmkf3V0z/bXrusC0so0n
	TIOMtTIvHL1965F/0D7NtenhQUosxRmJhlrMRcWJAKn4D1/qAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd2k8MhAg+V/OS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzFhzqom94AlfxYrGB8wNjLN4uhg5OSQETCT2
	Ld/EDmGLSVy4t56ti5GLQ0hgEaPE9UlvWSGcX4wSp1b+ZAWpYhNQk/jy5TBQBweHiIC+RFuL
	BkgNs0Avo8SZ3t1gk4QEbCV+nP3ODGJzCthJvFk4jxHEFhawl2i6cQKshkVAVWL6z0NMIDYv
	UP3/1jesELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEii4+EbZogS
	EYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGJ
	4Jn0DsZVDRaHGAU4GJV4eCMuRAQKsSaWFVfmHmKU4GBWEuH1+QYU4k1JrKxKLcqPLyrNSS0+
	xJgM9OhEZinR5HxgksoriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYm
	Dk6pBkbNb8GxEc4zHdw5s59Y/prc+8ub36P7bJzcm4WlpUHvKo9dKBMr+WqwUfXTo9mXoh6n
	MOz5tCC1nz/j29qkFwpVIkatXGr5RSbqmZrzQx4HzKs4ZHiKfcWDnL25u1KPKgg71wSuF+v6
	fTEw/M3SdWczKqY5BmyX2FC8NfRI7h7zOJlPur079yuxFGckGmoxFxUnAgAAJyblSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max8998.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index 8f234a0..48b6612 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -256,7 +256,8 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 	struct max8998_rtc_info *info;
 	int ret;
 
-	info = kzalloc(sizeof(struct max8998_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max8998_rtc_info),
+			GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -267,7 +268,7 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, info);
 
-	info->rtc_dev = rtc_device_register("max8998-rtc", &pdev->dev,
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max8998-rtc",
 			&max8998_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
@@ -276,8 +277,8 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
-			"rtc-alarm0", info);
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
+				max8998_rtc_alarm_irq, 0, "rtc-alarm0", info);
 
 	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
@@ -294,20 +295,11 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 
 out_rtc:
 	platform_set_drvdata(pdev, NULL);
-	kfree(info);
 	return ret;
 }
 
 static int max8998_rtc_remove(struct platform_device *pdev)
 {
-	struct max8998_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info) {
-		free_irq(info->irq, info);
-		rtc_device_unregister(info->rtc_dev);
-		kfree(info);
-	}
-
 	return 0;
 }
 
-- 
1.7.2.5


