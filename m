Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3CFF3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:29:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48351 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3CFF3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:29:14 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-9a-5136d42351a0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 06/30] rtc: rtc-ds1511: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:29:07 +0900
Message-id: <004801ce1a2b$85e4e6d0$91aeb470$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAADv9g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA13lK2aBBqe/yFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MM284Cw5wVrw/e4i9gfEtexcjJ4eEgInEjo2H2CBsMYkL99YD
	2VwcQgLLGCX2bpoLV/Ry2UcWiMQiRomTLe8YIZzZTBK3FzWBVbEJqEl8+XIYyObgEBHQl2hr
	0QCpYRboZZQ407sbrEZIwFbiavcqZhCbU8BOYvnjWSwgtrCAm8SGF8dZQWwWAVWJd++3MYHY
	vED12692s0DYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJ1obVUOUi
	EvteQNwsIbCIXWLmxSfsELsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9CsnkW
	khULGFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoREVv8OxrsHrA8xJgOtn8gsJZqcD4zM
	vJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgtPE0
	cFotNmuDtPz+NeYRM30XcydF3OOaVdXqpsrp+XpVrPU33veldW5TCr+ftP1odsK1fBljhdec
	14cP77f8NHfCqdmHf9VKPWTa87L5zryNmx4rTIhZe6NMrG92mPqFH37JarWJZ+4/eLG1mFuH
	Ue/aFoYQ1yOOZRd87LYlzL1SoSLxVGWDuRJLcUaioRZzUXEiALeqWnnCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK7yFbNAg0nTpC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpk3nAUHOCvenz3E3sD4
	lr2LkZNDQsBE4uWyjywQtpjEhXvr2boYuTiEBBYxSpxseccI4cxmkri9qAmsg01ATeLLl8NA
	NgeHiIC+RFuLBkgNs0Avo8SZ3t1gNUICthJXu1cxg9icAnYSyx/PAtsgLOAmseHFcVYQm0VA
	VeLd+21MIDYvUP32q90sELagxI/J98BsZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETA
	SKK1YTVUuYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzguH0mtYNxZYPFIUYBDkYlHl4LJbNAIdbEsuLK3EOMEhzMSiK8XGeAQrwpiZVVqUX5
	8UWlOanFhxiTgR6dyCwlmpwPTCl5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2a
	WpBaBLOFiYNTqoFx8t/4WMv+xw8OW0+RlLG1f7AhYOPmr+qf07iPTpxnaqVgYJwT3fvnZ0Xe
	0i2np8h0/Bb95DVLNzB0qna9/bIYsd87Ff6nMr4yC2SXUjq4obQ+L1UxMDnw96I4ZYWX/s2F
	S85d0W67ujhv6vqnjvUT90Sps3UKHpz4ce3HxZcYtZK97HZ+FWJTYinOSDTUYi4qTgQAn+pS
	4x8DAAA=
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
 drivers/rtc/rtc-ds1511.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 6a3fcfe..e7f16f9 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -538,15 +538,14 @@ static int ds1511_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &ds1511_rtc_ops,
-		THIS_MODULE);
+	rtc = devm_rtc_device_register(pdev->name, &pdev->dev, &ds1511_rtc_ops,
+					THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
-	if (ret)
-		rtc_device_unregister(pdata->rtc);
+
 	return ret;
 }
 
@@ -555,7 +554,6 @@ static int ds1511_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0) {
 		/*
 		 * disable the alarm interrupt
-- 
1.7.2.5


