Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3CFFfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:35:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29333 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3CFFey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:34:54 -0500
X-AuditID: cbfee68d-b7f636d0000009be-b4-5136d5793925
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 23/30] rtc: rtc-stk17ta8: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:34:49 +0900
Message-id: <005901ce1a2c$51ad7b10$f5087130$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAQ1Mw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA93Kq2aBBvf6pCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGiVubGQuOc1acWNrK2sDYwNHFyMkhIWAiMWv7PjYIW0ziwr31
	QDYXh5DAMkaJ97O+scIU3Tj6kx3EFhJYxCixoLkaomg2k8S3lb3MIAk2ATWJL18OAxVxcIgI
	6Eu0tWiA1DAL9DJKnOndDdVsK3G1exVYPaeAncTyx7NYQGxhAQ+JjjXbwJaxCKhKnHh9Aqye
	F6i+eWsnC4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLcYKRxJtOP4gKEYl9
	L94xgpwjIbCIXWL1tnUsEKsEJL5NPsQC0SorsekAM8S7khIHV9xgmcAoMQvJ4llIFs9CsngW
	khULGFlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoTEVe8OxtsHrA8xJgOtn8gsJZqcD4zL
	vJJ4Q2NjEzMTUxNzS1NzU9KElcR55S7JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgZJx4
	j+3U+nk3XCKXHwvYE22rtqTNpv3e9RPGme4efDxyofnz3NJZnaPOv9uWkPLZYmKPQPU7hlfd
	C3tLagSzFhve3Z7dtmuPaX5mbmLA0l97d+3cVCZ/eYqNx5OTl04pTV0ySa1Hc/X7tV/MPF+Y
	pgYXO5W/i6lrvCP72jvlnCZrjmmkRlqnEktxRqKhFnNRcSIAFLK2xMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7lVbNAg517RSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxolbmxkLjnNWnFjaytrA
	2MDRxcjJISFgInHj6E92CFtM4sK99WwgtpDAIkaJBc3VXYxcQPZsJolvK3uZQRJsAmoSX74c
	Bmrg4BAR0Jdoa9EAqWEW6GWUONO7mx2i2VbiavcqsHpOATuJ5Y9nsYDYwgIeEh1rtrGC2CwC
	qhInXp8Aq+cFqm/e2skCYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6kKcYCTx
	ptMPokJEYt+Ld4wTGIVmIRk0C8mgWUgGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcNQ+k9rBuLLB4hCjAAejEg+vhZJZoBBrYllxZe4hRgkOZiURXq4zQCHelMTKqtSi/Pii
	0pzU4kOMyUB/TmSWEk3OByaUvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8sSc1OTS1I
	LYLZwsTBKdXAePJuyz1B3Q/fGcV3+T86VCl39WbpuuXdC8tqqi+eLldxfKX02XLtg/A5Z9N3
	WW2fY3N47ulNP5gUA5NXdRkvf9vOxswac2zF3o2ev7dnnZl0uebHuvXuJ9b15LZESNx+z3L3
	5+n7QUU7dBxWOcv9KuJYIFfgVa4WLHpju2iP++GA5/+1V74MWKrEUpyRaKjFXFScCADWiG9H
	HgMAAA==
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
 drivers/rtc/rtc-stk17ta8.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 7e4a6f6..f27ad04 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -336,14 +336,13 @@ static int stk17ta8_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	pdata->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				  &stk17ta8_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pdata->rtc))
 		return PTR_ERR(pdata->rtc);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	if (ret)
-		rtc_device_unregister(pdata->rtc);
+
 	return ret;
 }
 
@@ -352,7 +351,6 @@ static int stk17ta8_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0)
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 	return 0;
-- 
1.7.2.5


