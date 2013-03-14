Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3CNIUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:20:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25764 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:20:40 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-d9-51418857f83b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 18/30] rtc: rtc-ps3: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:20:39 +0900
Message-id: <009501ce208c$cfb048b0$6f10da10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAWbDw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zQ93wDsdAg+b50hZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBl/G30LVjMXnHr036WBsZmti5GDg4JAROJZ60uXYycQKaYxIV769lAbCGBZYwSb1Zx
	w5ScOVIHEZ7OKPHqYgaE/YtR4v4KExCbTUBN4suXw+wg5SIC+hJtLRpdjFwczAK9jBJneneD
	xYUEbCWu/7cDMTkF7CQ2rBcD6RQWcJZ4tXIBC0iYRUBV4vANsDAvUPH+ORuYIGxBiR+T77GA
	2MwCWhLrdx5ngrDlJTavecsMcaO6xKO/uiBhEQEjiTU3tzFDlIhI7HvxjhHkGAmBa+wSCxdP
	ZARJsAgISHybfIgFoldWYtMBZkgQSEocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBc
	UJyUXmSsV5yYW1yal66XnJ+7iRESmf07GO8esD7EmAy0fiKzlGhyPjCy80riDY3NjCxMTUyN
	jcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmMsWosXZVsLodFSjxPbW
	O5MpE2zzRBXaP4afXqya8uj2dX37MnnjJzx7vpg3VRelSvfcy/jbrRq50lGYz63a/ai9TX6t
	rC7Tg1+6nb6bN2b9P2+gI5vn+r228cj/jpliExf+0PlxOu6RtcDTaTGK3WJzXzzpen6q02by
	OqEZzTruIXyZFv1KLMUZiYZazEXFiQDFXqtQ4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd3wDsdAg9X/xSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPjb6FuwmL3i1qf9LA2MzWxdjBwcEgImEmeO
	1HUxcgKZYhIX7q1nA7GFBKYzSry6mAFh/2KUuL/CBMRmE1CT+PLlMDtIq4iAvkRbi0YXIxcH
	s0Avo8SZ3t1gcSEBW4nr/+1ATE4BO4kN68VAOoUFnCVerVzAAhJmEVCVOHwDLMwLVLx/zgYm
	CFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jJD3Ksu8eivLkhYRMBIYs3NbcwQJSIS+168Y5zA
	KDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY/+Z1A7GlQ0W
	hxgFOBiVeHgP9DsECrEmlhVX5h5ilOBgVhLh9fRyDBTiTUmsrEotyo8vKs1JLT7EmAz050Rm
	KdHkfGBayiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRru0
	eBWONN25Yuui9jBbb7I6Iby4uqqu89HrfToLVvoLM91q7Q3tqTumn6j7Q/1f3oMbYuFRu5py
	/4a12gVxmn54s/vUYYmrluZ+k/YwPxE7/v9uR2zJUdYv/dGplh3nSqr3+M3ksD2/a89U4Svm
	/3Ll5fgSL2ad2fxb0mxVDcdSNpHqeeFGSizFGYmGWsxFxYkAww4JPkEDAAA=
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
 drivers/rtc/rtc-ps3.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
index 846722d..4bb825b 100644
--- a/drivers/rtc/rtc-ps3.c
+++ b/drivers/rtc/rtc-ps3.c
@@ -62,7 +62,7 @@ static int __init ps3_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("rtc-ps3", &dev->dev, &ps3_rtc_ops,
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-ps3", &ps3_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -73,7 +73,6 @@ static int __init ps3_rtc_probe(struct platform_device *dev)
 
 static int __exit ps3_rtc_remove(struct platform_device *dev)
 {
-	rtc_device_unregister(platform_get_drvdata(dev));
 	return 0;
 }
 
-- 
1.7.2.5


