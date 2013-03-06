Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3CFH5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:57:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3CFH5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:57:20 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-3d-5136f6d80a7a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 29/30] rtc: rtc-vt8500: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:57:12 +0900
Message-id: <009701ce1a40$35f8f3e0$a1eadba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAV4IA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI90b38wCDTY+MLG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ718sYiv4yF2xdckz1gbG+5xdjJwcEgImEuva17JA2GISF+6t
	Z+ti5OIQEljGKLHuwS0ghwOs6Mk8Doj4IkaJ2Z3bmCCc2UwSk06/YATpZhNQk/jy5TA7SIOI
	gL5EW4sGSA2zQC+jxJne3WBxIQFbiZ55PCDlnAJ2ElMmPmYHsYUFPCXubXsBdgSLgKrEpmNX
	wUbyApXfOneEFcIWlPgx+R5YDbOAlsT6nceZIGx5ic1r3jJD3Kku8eivLkhYRMBI4vm9djaI
	EhGJfS/eMYKcIyGwjF3iUsNVNohdAhLfJh9igeiVldh0gBkSDpISB1fcYJnAKDELyeZZSDbP
	QrJ5FpIVCxhZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKExFX/Dsa7B6wPMSYDrZ/ILCWa
	nA+My7ySeENjYxMzE1MTc0tTc1PShJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YJy/5exFR8uzM1KfB3MfZnF4+d2yzu3ntZUnvV7u+FPOP0VFq+2534F/Ex8wn3rHue/iXQZz
	bp3dl4yyz63yPW3lbrp2D8P+tc/PWgow9zQEl22znLjlyKbuV6p8lxnTYjI548v6ZPy+ySyd
	efWRZc3UrfUsIRczlL2ZYv8m8ERMr9Hbc5DzXrUSS3FGoqEWc1FxIgA2x2PXwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO6Nb2aBBo83GVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjPcvFrEVfOSu2LrkGWsD
	433OLkYODgkBE4kn8zi6GDmBTDGJC/fWs3UxcnEICSxilJjduY0JwpnNJDHp9AtGkCo2ATWJ
	L18Os4M0iwjoS7S1aIDUMAv0Mkqc6d0NFhcSsJXomccDUs4pYCcxZeJjdhBbWMBT4t62Fywg
	NouAqsSmY1fBRvICld86d4QVwhaU+DH5HlgNs4CWxPqdx5kgbHmJzWveMkPcrC7x6K8uSFhE
	wEji+b12NogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMFR+0x6B+OqBotDjAIcjEo8vBNUzAKFWBPLiitzDzFKcDArifBynQEK8aYkVlal
	FuXHF5XmpBYfYkwGenQis5Rocj4woeSVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6Yklq
	dmpqQWoRzBYmDk6pBkaBHyEyu+ymzL5lzaYyaV7gujXrmG9bZa714RIXePE9aa7F3n8F0/8L
	6Z+322N2eK7c5fsvUnbvOThTc5GvQ1rt/4RoxRNqQVOaVX7Nv7wmrXX360LtFUYCTMkX3rn9
	WLUxJ0V9/vR3v2ZP+HU+78t6sWcSbrYvDzaxr7kT9v6ET/3Hk9E3dRN7lFiKMxINtZiLihMB
	dRR56B4DAAA=
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

 drivers/rtc/rtc-vt8500.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index a000bc0..d89efee 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -252,7 +252,7 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 	writel(VT8500_RTC_CR_ENABLE,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
-	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,
+	vt8500_rtc->rtc = devm_rtc_device_register(&pdev->dev, "vt8500-rtc",
 					      &vt8500_rtc_ops, THIS_MODULE);
 	if (IS_ERR(vt8500_rtc->rtc)) {
 		ret = PTR_ERR(vt8500_rtc->rtc);
@@ -266,13 +266,11 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 			vt8500_rtc->irq_alarm, ret);
-		goto err_unreg;
+		goto err_return;
 	}
 
 	return 0;
 
-err_unreg:
-	rtc_device_unregister(vt8500_rtc->rtc);
 err_return:
 	return ret;
 }
@@ -281,8 +279,6 @@ static int vt8500_rtc_remove(struct platform_device *pdev)
 {
 	struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(vt8500_rtc->rtc);
-
 	/* Disable alarm matching */
 	writel(0, vt8500_rtc->regbase + VT8500_RTC_IS);
 
-- 
1.7.2.5


