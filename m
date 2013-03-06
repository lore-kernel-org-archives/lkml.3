Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3CFHuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:50:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52209 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3CFHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:50:15 -0500
X-AuditID: cbfee690-b7f6b6d000004563-58-5136f5309bff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 08/30] rtc: rtc-ds1742: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:50:08 +0900
Message-id: <008201ce1a3f$38fe6120$aafb2360$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAGESg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI12Dr2aBBpsPS1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MeX3L2Qq2cVW0nNnI0sB4iaOLkZNDQsBEYtWKZewQtpjEhXvr
	2boYuTiEBJYxSjy9tZcVpmjKt/PMEIlFjBIv//dBVc1mkjj/7SsLSBWbgJrEly+HgUZxcIgI
	6Eu0tWiA1DAL9DJKnOndDRYXErCV6JnHA1LOKWAnMWXiY7DNwgKeEntO7wUbwyKgKtF3+TYj
	iM0LVL7x7UNWCFtQ4sfke2A1zAJaEut3HmeCsOUlNq95ywwyXkJAXeLRX12QsIiAkcT91Suh
	SkQk9r14xwhyjoTAMnaJ1092sELsEpD4NvkQC0SvrMSmA8wQ/0pKHFxxg2UCo8QsJJtnIdk8
	C8nmWUhWLGBkWcUomlqQXFCclF5kolecmFtcmpeul5yfu4kRElkTdjDeO2B9iDEZaP1EZinR
	5HxgZOaVxBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A+Oi8xnOJo1fzbUYpv15qve98enKsgMZX7Sv7pmjax/085eI0O7dWzPW+++ozHMOEt70fu5S
	3Wtn9wcG/332/6ufw3YuJquvUuxX/QN2cp1Id+pZdsgkMsjz7LtFPK8tyssmW31v3DEx+6Lr
	kdvM72Xmbn5U9sNXNivv9aTVJ6QTDz4/cOiaKPcDJZbijERDLeai4kQA37QSGsICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK7BV7NAg+tPRSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxry+5WwF27gqWs5sZGlg
	vMTRxcjJISFgIjHl23lmCFtM4sK99WxdjFwcQgKLGCVe/u+DcmYzSZz/9pUFpIpNQE3iy5fD
	7F2MHBwiAvoSbS0aIDXMAr2MEmd6d4PFhQRsJXrm8YCUcwrYSUyZ+JgdxBYW8JTYc3ov2BgW
	AVWJvsu3GUFsXqDyjW8fskLYghI/Jt8Dq2EW0JJYv/M4E4QtL7F5zVtmkPESAuoSj/7qgoRF
	BIwk7q9eCVUiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzhun0nvYFzVYHGIUYCDUYmHd4KKWaAQa2JZcWXuIUYJDmYlEV6uM0Ah3pTEyqrU
	ovz4otKc1OJDjMlAj05klhJNzgemlLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnN
	Tk0tSC2C2cLEwSnVwMgdrWzJJuXFfLiDxSfnui6v4NpFTwR7/FnDeyI+zdE/KtrS7XH45IPL
	SlMli+cuTLCymbSxdY/SRHeGrPO7++pfz5n3vPrnv6Ml/tdexoVLNPleCZ++IWnfwc3zf757
	cWrFZD7fhaY+r26fk7v/a6Ke4qKazz8u8fQ3lxjFrtP4wby4bebuwiNKLMUZiYZazEXFiQDf
	Rm6gHwMAAA==
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-ds1742.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 609c870..eccdc62 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -208,17 +208,14 @@ static int ds1742_rtc_probe(struct platform_device *pdev)
 
 	pdata->last_jiffies = jiffies;
 	platform_set_drvdata(pdev, pdata);
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &ds1742_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
-	if (ret) {
-		dev_err(&pdev->dev, "creating nvram file in sysfs failed\n");
-		rtc_device_unregister(rtc);
-	}
+
 	return ret;
 }
 
@@ -227,7 +224,6 @@ static int ds1742_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


