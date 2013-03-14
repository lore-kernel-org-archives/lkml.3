Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3CNIP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:15:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31995 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3CNIPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:15:24 -0400
X-AuditID: cbfee68e-b7f946d000001e37-ed-5141871b2be3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 12/30] rtc: rtc-ls1x: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:15:22 +0900
Message-id: <008f01ce208c$12f3f050$38dbd0f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAKsOQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zfV3pdsdAg4P72C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuPqii6ngPXvFzo9vmRsYj7F1MXJySAiYSEx6M58FwhaTuHBvPVCci0NIYBmjxLTF
	e1lgirq33mSGSExnlPhwZiU7hPOLUWLt1JuMIFVsAmoSX74cBkpwcIgI6Eu0tWiA1DAL9DJK
	nOndDRYXErCVuP7fDsTkFLCT2LBeDMQUFnCROPM1H2QIi4CqxOt5r5lBwrxAxfu+1oKEeQUE
	JX5Mvgd2DbOAlsT6nceZIGx5ic1r3oKVSwioSzz6qwsSFhEwkng2/zlUiYjEvhfvGEFukRC4
	xS7x/dVCdohVAhLfJh9igeiVldh0gBniWUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhF
	UwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCYrRvB+PNA9aHGJOB1k9klhJNzgfGeF5JvKGxmZGF
	qYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGKV/va1Tm1Lx0TAp
	f6v9yqXr73DwSIru3idbLfSCa9nc2/U3upqMBW/VL7Z+773ny7SSeT87H8Uzrgq1PmTxpr4k
	5KX6+qKgs3slVRd8OPEhkklsp+jB6Xy5oSEN2xwneH1izY7MY4n7m6HJH7WY7bmV/eo/2qIL
	J23x5skUZDa7Jug289UrIyWW4oxEQy3mouJEAF8FsT3nAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQV3pdsdAg+4dzBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZlx90cVU8J69YufHt8wNjMfYuhg5OSQETCS6
	t95khrDFJC7cWw8U5+IQEpjOKPHhzEp2COcXo8TaqTcZQarYBNQkvnw5DJTg4BAR0Jdoa9EA
	qWEW6GWUONO7GywuJGArcf2/HYjJKWAnsWG9GIgpLOAiceZrPsgQFgFVidfzXjODhHmBivd9
	rQUJ8woISvyYfI8FxGYW0JJYv/M4E4QtL7F5zVuwcgkBdYlHf3VBwiICRhLP5j+HKhGR2Pfi
	HeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnACeSe9g
	XNVgcYhRgINRiYc3QtQxUIg1say4MvcQowQHs5IIr6cXUIg3JbGyKrUoP76oNCe1+BBjMtCf
	E5mlRJPzgckpryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY
	NUP3XzkTbX3hchq/yCpF/hUnxDYI6P9/OMHGZUcug7aInmjZggO9qcI8e62XvbXuV9q7Ta69
	Z2vCukDWcJ2UY0Inz265csSgg6EvtYrTlOW3dHDKqhubVy5oUjm0c5HJkf8HKuYzcX2pLL/z
	QUFq1zy3IK/Hnif6ck8z5h8u3aYR/XNDW+NCJZbijERDLeai4kQA1kn0U0QDAAA=
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
 drivers/rtc/rtc-ls1x.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-ls1x.c b/drivers/rtc/rtc-ls1x.c
index f59b634..db82f91 100644
--- a/drivers/rtc/rtc-ls1x.c
+++ b/drivers/rtc/rtc-ls1x.c
@@ -172,7 +172,7 @@ static int ls1x_rtc_probe(struct platform_device *pdev)
 	while (readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TTS)
 		usleep_range(1000, 3000);
 
-	rtcdev = rtc_device_register("ls1x-rtc", &pdev->dev,
+	rtcdev = devm_rtc_device_register(&pdev->dev, "ls1x-rtc",
 					&ls1x_rtc_ops , THIS_MODULE);
 	if (IS_ERR(rtcdev)) {
 		ret = PTR_ERR(rtcdev);
@@ -187,9 +187,6 @@ err:
 
 static int ls1x_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtcdev = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtcdev);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


