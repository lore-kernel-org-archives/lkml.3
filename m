Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3CNIOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:14:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42659 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3CNIOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:14:42 -0400
X-AuditID: cbfee68d-b7f786d000005188-8a-514186f1a1e6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 10/30] rtc: rtc-generic: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:14:40 +0900
Message-id: <008d01ce208b$fa30fae0$ee92f0a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAJCjg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zI92PbY6BBkuvCVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MyUs3shXM4KhY03SavYHxCVsXIyeHhICJxKoNp5ggbDGJC/fW
	g8WFBJYxSlw+4gxTs3frJHaI+CJGiZbtlV2MXED2bCaJoxfPMIMk2ATUJL58OQxUxMEhIqAv
	0daiAVLDLNDLKHGmdzdYXEjAVuL6fzsQk1PATmLDejGQTmEBd4m1Zx6AncAioCrxeepesFW8
	QNXvt39gg7AFJX5MvscCYjMLaEms33mcCcKWl9i85i0zyEgJAXWJR391QcIiAkYSj75BfMgs
	ICKx78U7RohPlrFLnL/jALFKQOLb5EMsEK2yEpsOMEOUSEocXHGDZQKjxCwki2chWTwLyeJZ
	SDYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESUb07GG8fsD7EmAy0fiKzlGhyPjAi
	80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmM21
	9YkVh4nge/W5P+bLHZJS/yPdbqR+afKVYKvMgs1zRNqyNa+ErNz301bqDN83lYrjR+2t5i7l
	PzF5xzaDS5FsRls+hXxl25DmxBkRrTq/U3mJ9vqOF7NeN5yKZ7dboeU5ff9azo+XTn4NvvYu
	3HnJpZQSuZ2bjryScpTLOt903qQz/s+kdiWW4oxEQy3mouJEAK/TvWq+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO7HNsdAg8nTuCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxuSlG9kKZnBUrGk6zd7A
	+ISti5GTQ0LARGLv1knsELaYxIV768HiQgKLGCVatld2MXIB2bOZJI5ePMMMkmATUJP48uUw
	UAMHh4iAvkRbiwZIDbNAL6PEmd7dYHEhAVuJ6//tQExOATuJDevFQDqFBdwl1p55wARiswio
	SnyeuhdsLS9Q9fvtH9ggbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywwyUkJAXeLRX12QsIiA
	kcSjbxCfMAuISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECI7ZZ9I7GFc1WBxiFOBgVOLhjRB1DBRiTSwrrsw9xCjBwawkwuvpBRTiTUmsrEot
	yo8vKs1JLT7EmAz06ERmKdHkfGA6ySuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGxvRWJXEP5qsFM9N4vRfdnes/+W+6cvj+jexSZxyWCOyb/sdmlvfWLyzH
	95QrhJpzrAlrWrbu1Blhw4O25383ftDp3/rV3lBiZ7WEckfmRFb7hGkL97xVlDxbfXy5cXSy
	10n9swzhig4aN1JeZX/aGLLtza+Hv17dffmrYvem66cevFN5sPe7hpwSS3FGoqEWc1FxIgBt
	KkOnHQMAAA==
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
 drivers/rtc/rtc-generic.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-generic.c b/drivers/rtc/rtc-generic.c
index 0bf4530..06279ce 100644
--- a/drivers/rtc/rtc-generic.c
+++ b/drivers/rtc/rtc-generic.c
@@ -38,8 +38,8 @@ static int __init generic_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("rtc-generic", &dev->dev, &generic_rtc_ops,
-				  THIS_MODULE);
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-generic",
+					&generic_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -50,10 +50,6 @@ static int __init generic_rtc_probe(struct platform_device *dev)
 
 static int __exit generic_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
-	rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


