Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3CFHvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:51:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46184 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3CFHvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:51:51 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-97-5136f596b9d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 13/30] rtc: rtc-max77686: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:51:47 +0900
Message-id: <008701ce1a3f$75e903b0$61bb0b10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAJvnw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA91pX80CDRr7LCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKWPtlM2vBMt6K/St/sDcwtnF3MXJySAiYSDw8OI8VwhaTuHBvPVsXIxeHkMAyRokX
	Z3pYYYqO3fjECJGYzihxff8mdgjnF6PErgcH2EGq2ATUJL58OQxkc3CICOhLtLVogNQwC/Qy
	Spzp3Q0WFxKwleiZxwNSzilgJzFl4mOwVmEBb4mPL56CLWMRUJVonb6LBcTmBSpvufyOFcIW
	lPgx+R5YnFlAS2L9zuNMELa8xOY1b5lBxksIqEs8+qsLEhYRMJLonX2GFaJERGLfi3dg90sI
	3GOX2Di5lQ1il4DEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG
	0dSC5ILipPQiU73ixNzi0rx0veT83E2MkEiduIPx/gHrQ4zJQOsnMkuJJucDIz2vJN7Q2NjE
	zMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhh3nzO4/ve2a3zv
	pzNcH06U95TM1r/9+O7UmbPOBp7N3DbhBMc95aMsQYYvjxftjN2rZNSWwOxwwLS0gmk9W/DL
	QxevLBM/dufs098hX0O8BXaGrTC0m7s444SmoFPSSueD65SnKeXOWSZ+oshy5u19131OdBl9
	E/11zSp648zUDzvWnFszpfjICiWW4oxEQy3mouJEAOOVzWjqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1pX80CDT7tMrZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPtl82sBct4K/av/MHewNjG3cXIySEhYCJx
	7MYnRghbTOLCvfVsXYxcHEIC0xklru/fxA7h/GKU2PXgADtIFZuAmsSXL4eBbA4OEQF9ibYW
	DZAaZoFeRokzvbvB4kICthI983hAyjkF7CSmTHwM1ios4C3x8cVTVhCbRUBVonX6LhYQmxeo
	vOXyO1YIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlBhkvIaAu8eivLkhYRMBIonf2GVaIEhGJ
	fS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeCZ
	9A7GVQ0WhxgFOBiVeHgnqJgFCrEmlhVX5h5ilOBgVhLh5ToDFOJNSaysSi3Kjy8qzUktPsSY
	DPToRGYp0eR8YIrKK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS1OzU1ILUIpgtTByc
	Ug2Mm5QCzrir1xzpyBA7fUp4+haFvv+X3104sb3RvSjE+mzFHhdT7y9xxfoPrt0JjVlS8dR0
	WfFt3TdRHnOVZwaFv1hf5P/z9ZbyJXNC1u1QnXa9f8/KmX+j+1/e0XG+sqknpzNE3CbyVWQu
	c8cxI5s3hUt4Wi9YVTnIuPYzbRRoS3mwZvGM6N/zlViKMxINtZiLihMBPc1dGEcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler. Also, this patch uses devm_request_threaded_irq().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-max77686.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index df66bab..5a12b32 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -538,8 +538,8 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register("max77686-rtc", &pdev->dev,
-			&max77686_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max77686-rtc",
+					&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
 		dev_info(&pdev->dev, "%s: fail\n", __func__);
@@ -555,8 +555,8 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 		goto err_rtc;
 	info->virq = virq;
 
-	ret = request_threaded_irq(virq, NULL, max77686_rtc_alarm_irq, 0,
-			"rtc-alarm0", info);
+	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
+				max77686_rtc_alarm_irq, 0, "rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->virq, ret);
@@ -569,13 +569,6 @@ err_rtc:
 
 static int max77686_rtc_remove(struct platform_device *pdev)
 {
-	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info) {
-		free_irq(info->virq, info);
-		rtc_device_unregister(info->rtc_dev);
-	}
-
 	return 0;
 }
 
-- 
1.7.2.5


