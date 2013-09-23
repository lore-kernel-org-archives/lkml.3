Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3IWJnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:43:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56156 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3IWJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:43:05 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-35-52400d28abff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'David Dajun Chen'" <dchen@diasemi.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 04/15] rtc: rtc-da9055: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:43:04 +0900
Message-id: <002001ceb841$4d063300$e7129900$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAIrLw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zA10NXocgg9W9ChZLLl5lt5izfg2b
	xepNO1ktLi+8BCR2zWGz2N/ZwejA5rHik77Hnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+SC2CL
	4rJJSc3JLEst0rdL4Mo4+fAMU8EVtoo1F+6xNTCeY+1i5OSQEDCR2NHWwwZhi0lcuLcezBYS
	WMYoMaXLAqam++F79i5GLqD4IkaJSb8es0I4vxglFv5vZAGpYhNQk/jy5TBQFQeHiIC+RFuL
	BkgNs8B2Rom5j7ZDTbWVmDjtKxOIzSlgJ7Hm8zImkHphIHvvOmaQMIuAqsSPl2fASniByj8t
	/c8CYQtK/Jh8D8xmFtCS2LytiRXClpfYvOYtM8gYCQF1iUd/dSEuMJJY+C8YokJEYt+Ld4wg
	10gIvGSX6N7/hA1ilYDEt8mHWCBaZSU2HWCGeFdS4uCKGywTGCVmIVk8C8niWUgWz0KyYgEj
	yypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkLjt38F494D1IcZkoPUTmaVEk/OBcZ9XEm9o
	bGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaEkINhT+11
	9gbe2Hj/syVrXo3Y6fmsG+5J/Lov5Lk8fMobh8onFx/0Hmr6tnD56WKbSQvPlWndr77oWv+w
	9sGVo+f+z70xx7DMZltHmfDWha8OLv4hVjHxbfb1MN60Zrc2y5P/Eu0mP1Jp2Xrzx7bGB/6f
	LbmFmJl7dQ+dEY3zn5h44O0svnVhSizFGYmGWsxFxYkAn4LTnvECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV0NXocgg9V9MhZLLl5lt5izfg2b
	xepNO1ktLi+8BCR2zWGz2N/ZwejA5rHik77Hnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+SC2CL
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6Q0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcfLhGaaCK2wVay7cY2tgPMfa
	xcjJISFgItH98D07hC0mceHeerYuRi4OIYFFjBKTfj1mhXB+MUos/N/IAlLFJqAm8eXLYaAO
	Dg4RAX2JthYNkBpmge2MEnMfbWcDqRESsJWYOO0rE4jNKWAnsebzMiaQemEge+86ZpAwi4Cq
	xI+XZ8BKeIHKPy39zwJhC0r8mHwPzGYW0JLYvK2JFcKWl9i85i0zyBgJAXWJR391IS4wklj4
	LxiiQkRi34t3jBMYhWYhGTQLyaBZSAbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZwWngmvYNxVYPFIUYBDkYlHt7IRPsgIdbEsuLK3EOMEhzMSiK8fqwOQUK8KYmVValF+fFF
	pTmpxYcYk4H+nMgsJZqcD0xZeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAuGxxz+mwh3vD5niuSLMQFrKOT1QwmGEne8uUac9E9fj9F25l7CwLyTBSfrPF
	Yxfjj0dhxbpP5ipt3vGS09FvjesF1q1/Gwo/r9p+OFpY8H4dW/60QLmEyZMeJrvNmjbxOSs/
	4+W009Uhm7ceKKoT/eNg4LHsiawqS0gZx6WPNmb8U4xft292VWIpzkg01GIuKk4EAKzW7cNP	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-da9055.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index e00642b..48cb2ac3 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -278,7 +278,7 @@ static int da9055_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	rtc->da9055 = dev_get_drvdata(pdev->dev.parent);
-	pdata = rtc->da9055->dev->platform_data;
+	pdata = dev_get_platdata(rtc->da9055->dev);
 	platform_set_drvdata(pdev, rtc);
 
 	ret = da9055_rtc_device_init(rtc->da9055, pdata);
-- 
1.7.10.4


