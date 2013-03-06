Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3CFFcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:32:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25723 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3CFFch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:32:37 -0500
X-AuditID: cbfee690-b7f6b6d000004563-0c-5136d4f4107f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 16/30] rtc: rtc-mv: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:32:35 +0900
Message-id: <005201ce1a2c$022845c0$0678d140$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAALxtA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA90vV8wCDc5uYrFYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY+Wpv4wFczgr1p6YytrAeIi9i5GTQ0LARKLz7iImCFtM4sK99WxdjFwcQgLLGCXu
	r7vPBlO0v/UwC0RiOqPEgT132CGcX4wSPUdvM4NUsQmoSXz5chgowcEhIqAv0daiAVLDLNDL
	KHGmdzfYOiEBW4mr3avA6jkF7CSWP57FAmILCzhJ/Hv1DCzOIqAqcX3KHLA5vED1y9aJgYR5
	BQQlfky+B1bOLKAlsX7ncSYIW15i85q3zCDlEgLqEo/+6oKERQSMJCa/OM8OUSIise/FO0aQ
	cyQE7rFL3Ox8xgaxSkDi2+RDLBC9shKbDjBD/CspcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCR
	ZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSKRO2MF474D1IcZkoPUTmaVEk/OBkZ5XEm9o
	bGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwZOnP3PHTN
	/y5mUeS8bdvxZMmU+ctVzoa5rHoSJ3hYZ7/tE75zxa8YAxOW6Ea/Z/lYtqdTQ+XiBIai/Q7c
	uW/UbDu+nCpv+LnozIYTlj81/SoZ2XvT+T7zixVO5Fv77vA6lTdMhw6usO57ZfLHL6jjrYA7
	i76S4yqntUIKx0VEv84VWhEed1uJpTgj0VCLuag4EQDRxlvF6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd3PV8wCDQ7+t7FYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPlqb+MBXM4K9aemMrawHiIvYuRk0NCwERi
	f+thFghbTOLCvfVsXYxcHEIC0xklDuy5ww7h/GKU6Dl6mxmkik1ATeLLl8NACQ4OEQF9ibYW
	DZAaZoFeRokzvbvBpgoJ2Epc7V4FVs8pYCex/PEssA3CAk4S/149A4uzCKhKXJ8yB2wOL1D9
	snViIGFeAUGJH5PvgZUzC2hJrN95nAnClpfYvOYtM0i5hIC6xKO/uiBhEQEjickvzrNDlIhI
	7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgPP
	pHYwrmywOMQowMGoxMNroWQWKMSaWFZcmXuIUYKDWUmEl+sMUIg3JbGyKrUoP76oNCe1+BBj
	MtCfE5mlRJPzgSkqryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFw
	SjUwrtwmuuxvrzBX8+KQCz6Wv5pNz1wJ5z188o/6vlsLJD6d9jrfviv4ZtKhhWvzjQ59bNNv
	OlfvfVshSlukRkxEbE96z+PdPhWM7EtEQ5/fv6TPNmsFW83yo0FJqYkXXctVLT+mF0exxFdl
	7rjnH3GvodTxwvQelVVcJ9+Gh0Up7WzfURHM9VdQiaU4I9FQi7moOBEAiDgspEcDAAA=
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
 drivers/rtc/rtc-mv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index 59d1671..5bedec9 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -262,12 +262,13 @@ static int __init mv_rtc_probe(struct platform_device *pdev)
 
 	if (pdata->irq >= 0) {
 		device_init_wakeup(&pdev->dev, 1);
-		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+		pdata->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 						 &mv_rtc_alarm_ops,
 						 THIS_MODULE);
-	} else
-		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	} else {
+		pdata->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 						 &mv_rtc_ops, THIS_MODULE);
+	}
 	if (IS_ERR(pdata->rtc))
 		return PTR_ERR(pdata->rtc);
 
@@ -291,7 +292,6 @@ static int __exit mv_rtc_remove(struct platform_device *pdev)
 	if (pdata->irq >= 0)
 		device_init_wakeup(&pdev->dev, 0);
 
-	rtc_device_unregister(pdata->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


