Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3CFFb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:31:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16795 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3CFFbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:31:55 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-a8-5136d4cae1ee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 14/30] rtc: rtc-max8907: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:31:53 +0900
Message-id: <005001ce1a2b$e940d860$bbc28920$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAKRMA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zfd1TV8wCDd628llc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MiR83MBdM4KzYeXIvUwPjefYuRg4OCQETiT2raroYOYFMMYkL
	99azdTFycQgJLGOUONRxixEiYSJx8vRPFojEIkaJWR9WsIAkhARmM0lMuMYFYrMJqEl8+XIY
	bKiIgL5EW4sGSD2zQC+jxJne3ewQ9bYSV7tXMYPYnAJ2EssfzwKbIyzgLrHkxDewOIuAqsTO
	X91gi3mB6t93XGaBsAUlfky+B2YzC2hJrN95nAnClpfYvOYtM8Qz6hKP/uqChEUEjCQ2HtrK
	DlEiIrHvxTuoX5axS0y6wAqxSkDi2+RDLBCtshKbDjBDlEhKHFxxg2UC0KNIFs9CsngWksWz
	kGxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkqvp2MN48YH2IMRlo/URmKdHkfGBU
	5pXEGxobm5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY1R5
	P1PVkp9xKeW3yq/Ob+peeOKTgPaMBb/e1oY9OjlJnjm2yizGRWOOpGJxhe5JuQWaUq2rvWz5
	989bvSJzjuzN7Tavd3SriFx4Gr6Ip9L9w33d94HTxQzqM13Dtpw4JMhd9YX/NlNB5eR4vl/a
	3fxb94ed3FeYse9w+53N86Rquxd8mjLXWomlOCPRUIu5qDgRAILfDnzAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO6pK2aBBg1LOCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxsSPG5gLJnBW7Dy5l6mB
	8Tx7FyMnh4SAicTJ0z9ZIGwxiQv31rN1MXJxCAksYpSY9WEFWEJIYDaTxIRrXCA2m4CaxJcv
	h4GaOThEBPQl2lo0QOqZBXoZJc707maHqLeVuNq9ihnE5hSwk1j+eBbYHGEBd4klJ76BxVkE
	VCV2/upmBLF5gerfd1xmgbAFJX5MvgdmMwtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiIC
	RhIbD21lhygRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERy3z6R2MK5ssDjEKMDBqMTDa6FkFijEmlhWXJl7iFGCg1lJhJfrDFCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84EpJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MHZ+nCi88JfPxLX7S9UT5wbmvH/dO3/akYmi/9JfbFtUbyRf6czGk+17
	Pepz3KT9vjoPc0qjLXnjtltI1P8OYW+88mbCzRsi/5snzrqxoXHFA/b0bQ8/JPxInbR6U2ow
	x6qv+daVu67oWPpIsJ/bqqm6lvVtD/+82Xwy9zlMV17fEfK0yNGYg1uJpTgj0VCLuag4EQAj
	SUc7HwMAAA==
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
 drivers/rtc/rtc-max8907.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-max8907.c b/drivers/rtc/rtc-max8907.c
index 31ca8fa..bcce6c6 100644
--- a/drivers/rtc/rtc-max8907.c
+++ b/drivers/rtc/rtc-max8907.c
@@ -190,7 +190,7 @@ static int max8907_rtc_probe(struct platform_device *pdev)
 	rtc->max8907 = max8907;
 	rtc->regmap = max8907->regmap_rtc;
 
-	rtc->rtc_dev = rtc_device_register("max8907-rtc", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register("max8907-rtc", &pdev->dev,
 					&max8907_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc_dev)) {
 		ret = PTR_ERR(rtc->rtc_dev);
@@ -217,16 +217,11 @@ static int max8907_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 err_unregister:
-	rtc_device_unregister(rtc->rtc_dev);
 	return ret;
 }
 
 static int max8907_rtc_remove(struct platform_device *pdev)
 {
-	struct max8907_rtc *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc->rtc_dev);
-
 	return 0;
 }
 
-- 
1.7.2.5


