Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3CFFf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:35:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29423 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3CFFfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:35:36 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-e0-5136d5a14012
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 25/30] rtc: rtc-tps6586x: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:35:29 +0900
Message-id: <005b01ce1a2c$69bb2a40$3d317ec0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAASPDA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ92FV80CDf5M1be4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjV/PMxdM4qx49ucrUwPjBfYuRk4OCQETiQ8Ll7JB2GISF+6t
	B7OFBJYxSny/UgRT8/X6MqYuRi6g+CJGiTU965ghnNlMEv0n7jCBVLEJqEl8+XIYaCoHh4iA
	vkRbiwZIDbNAL6PEmd7d7BBTbSWudq9iBrE5Bewklj+exQJiCwt4SLw484ANpJdFQFXi0css
	kDAvUPn2K1NZIWxBiR+T74GVMwtoSazfeZwJwpaX2LzmLTNIq4SAusSjv7oQFxhJ3HsqC1Eh
	IrHvxTtGkGskBBaxS9xsOAA2hkVAQOLb5EMsEK2yEpsOMEO8KylxcMUNlgmMErOQLJ6FZPEs
	JItnIVmxgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIVPXvYLx7wPoQYzLQ+onMUqLJ
	+cCozCuJNzQ2NjEzMTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xrTvO02fih2ZVyg6bdfU5Nji/njJW75L59ec5tnooWjd/NKlQKomVD6+oiTCeUO9yaOp5TcD
	n/foLnC8x/KtYs2l9c+lYvvSv2lkt2f/aGk9IXXo96pDi1LUC6RNvop7brfoy5ufG67v8LG8
	uWpSDesEV4/dnnfyWXW75gryt+lUuEw5u3+1EktxRqKhFnNRcSIAulUfsMACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7Cq2aBBsuWalpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMav55kLJnFWPPvzlamB
	8QJ7FyMnh4SAicTX68uYIGwxiQv31rN1MXJxCAksYpRY07OOGcKZzSTRf+IOWBWbgJrEly+H
	gbo5OEQE9CXaWjRAapgFehklzvTuBpsqJGArcbV7FTOIzSlgJ7H88SwWEFtYwEPixZkHbCC9
	LAKqEo9eZoGEeYHKt1+ZygphC0r8mHwPrJxZQEti/c7jTBC2vMTmNW+ZQVolBNQlHv3VhbjA
	SOLeU1mIChGJfS/eMU5gFJqFZNAsJINmIRk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBUftMegfjqgaLQ4wCHIxKPLwTVMwChVgTy4orcw8xSnAwK4nwcp0BCvGmJFZWpRbl
	xxeV5qQWH2JMBnpzIrOUaHI+MKHklcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBAemJJanZq
	akFqEcwWJg5OqQbGmfWcNXNuRdt2xf49WqQZwzGXWaHQU4//TZHMz5MHE6wmmKzU/sByiqPi
	yXJLZ81vB5m+NZw903NgNpdv9B/5F+0ng/c7c3MruK607J+qPrVCVySgOfs1p5GufPzeRcss
	RP88NHj6d7NCc1hA6MyQVxfmrH7rcDvZ3ikqtb/xZ5Cvj01PxDIlluKMREMt5qLiRADxglVY
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
 drivers/rtc/rtc-tps6586x.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index aab4e8c..9b82ff1 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -274,7 +274,7 @@ static int tps6586x_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtc = rtc_device_register(dev_name(&pdev->dev), &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(dev_name(&pdev->dev), &pdev->dev,
 				       &tps6586x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -306,12 +306,10 @@ fail_rtc_register:
 
 static int tps6586x_rtc_remove(struct platform_device *pdev)
 {
-	struct tps6586x_rtc *rtc = platform_get_drvdata(pdev);
 	struct device *tps_dev = to_tps6586x_dev(&pdev->dev);
 
 	tps6586x_update(tps_dev, RTC_CTRL, 0,
 		RTC_ENABLE | OSC_SRC_SEL | PRE_BYPASS | CL_SEL_MASK);
-	rtc_device_unregister(rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


