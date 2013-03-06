Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3CFFgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:36:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26360 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3CFFgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:36:33 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-06-5136d5dfc435
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 28/30] rtc: rtc-tx4939: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:36:31 +0900
Message-id: <005e01ce1a2c$8ec5e460$ac51ad20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAUaVg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zI937V80CDXa8NLNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEro//UJJaCG1wVBy/tYW9gbObsYuTgkBAwkej7V9XFyAlkiklcuLeerYuRi0NIYBmj
	xPvOJWwwNTf3lkDEpzNKzGn5wAjh/GKUuDX9NSNIN5uAmsSXL4fZQRpEBPQl2lo0QGqYBXoZ
	Jc707mYHqRESsJW42r2KGcTmFLCTWP54FguILSzgJjHz+D1WkF4WAVWJNZMdQUxeoPJDl0NA
	KngFBCV+TL4HVs0soCWxfudxJghbXmLzmrfMEGeqSzz6qwsSFhEwknh3aBEbRImIxL4X78Au
	lhB4xC6xaeJFsASLgIDEt8mHWCB6ZSU2HWCGBIOkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJG
	llWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYITHat4Px5gHrQ4zJQOsnMkuJJucDYzyvJN7Q
	2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi7FQ8tuX2I
	oZS7RezazM+bt54xU/mxeltz1ptjZ5dct97AKi587ahn/VxFlm91WZuDzpjOmXLB6arqH/62
	YA+Fx6u2C+rsrKk6pWPGUzdp1WV/F5UZOtuDSicEvg6+teFml6+c1qHPESt/rPq46ddJ+bk8
	58NWqgkl2XsUz/y+o65Wbs40Dh0uJZbijERDLeai4kQAVzbO3ucCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd37V80CDda9NrRYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaP/1CSWghtcFQcv7WFvYGzm7GLk4JAQMJG4
	ubeki5ETyBSTuHBvPVsXIxeHkMB0Rok5LR8YIZxfjBK3pr9mBKliE1CT+PLlMDtIs4iAvkRb
	iwZIDbNAL6PEmd7d7CA1QgK2Ele7VzGD2JwCdhLLH89iAbGFBdwkZh6/xwrSyyKgKrFmsiOI
	yQtUfuhyCEgFr4CgxI/J98CqmQW0JNbvPM4EYctLbF7zlhniZHWJR391QcIiAkYS7w4tYoMo
	EZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGc
	Ap5J72Bc1WBxiFGAg1GJh3eCilmgEGtiWXFl7iFGCQ5mJRFerjNAId6UxMqq1KL8+KLSnNTi
	Q4zJQG9OZJYSTc4Hpqe8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnC
	xMEp1cBo/lTRaZX461uzVj30ObB0sfJBnxdl55LbmwQ//Yxn3hy9Z3f93UsVgZ8vbjrOl13b
	6cEn/tFqmXDerNURTyTlVUT6l7Ad1Yq9zXDE62Ovu7Ve+kaVC4m6V5sPt+kY7S7/7+W7ynr9
	A1ffU20XJB3L9mcWOr3YF5fazcdxZ8WhKvZHE6Xv6WQosRRnJBpqMRcVJwIARrviIEUDAAA=
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
 drivers/rtc/rtc-tx4939.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index a12bfac..9643116 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -268,14 +268,13 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
 			     0, pdev->name, &pdev->dev) < 0)
 		return -EBUSY;
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				  &tx4939_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
-	if (ret)
-		rtc_device_unregister(rtc);
+
 	return ret;
 }
 
@@ -284,7 +283,6 @@ static int __exit tx4939_rtc_remove(struct platform_device *pdev)
 	struct tx4939rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	spin_lock_irq(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	spin_unlock_irq(&pdata->lock);
-- 
1.7.2.5


