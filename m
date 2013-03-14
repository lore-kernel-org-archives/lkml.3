Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3CNIXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:23:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26359 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3CNIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:23:34 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-8e-5141890577a9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 27/30] rtc: rtc-test: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:23:33 +0900
Message-id: <009e01ce208d$376c11f0$a64435d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAc9XQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zA13WTsdAg0nLFC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGw/pGtoIHnBW9t84zNzB2cHQxcnJICJhIfH23ihHCFpO4cG89
	WxcjF4eQwDJGiW/fPrDCFD3tWsICYgsJLGKUWNOsAWHPZpL4tyAHxGYTUJP48uUwexcjB4eI
	gL5EW4sGyBxmgV5GiTO9u8HiQgK2Etf/24GYnAJ2EhvWi4F0Cgu4SBw8d54FJMwioCqx4LUm
	SJgXqPjS5bPMELagxI/J98AOYBbQkli/8zgThC0vsXnNW2aQVgkBdYlHf3VBwiICRhIb1vQx
	QpSISOx78Q7qwXnsEj+ua4HYLAICEt8mH2KBaJWV2HSAGaJEUuLgihssExglZiFZPAvJ4llI
	Fs9CsmEBI8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJB46t/BePeA9SHGZKD1E5mlRJPz
	gfGYVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	WfpeTB3nncRnnb11RPTNra0bI9LPMd5bElMixllTFsWQ7zpVqPVqVFfrlLtViWvue4q0N+Q9
	5lfdWr/+0mWhw8f/PLEVuBf91+nH1Ki7pju85++b282to18r11/0Sqn8+eYJlUXdn9fYW4Qe
	s39ruOijTFjr6QgNcxbH3+ai2YmsfT2bZyQqsRRnJBpqMRcVJwIAJnpMuL0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgC5rp2OgweRP0haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo2F9I1vBA86K3lvnmRsY
	Ozi6GDk5JARMJJ52LWGBsMUkLtxbzwZiCwksYpRY06wBYc9mkvi3IAfEZhNQk/jy5TB7FyMH
	h4iAvkRbC1AJFwezQC+jxJne3WBxIQFbiev/7UBMTgE7iQ3rxUA6hQVcJA6eO88CEmYRUJVY
	8FoTJMwLVHzp8llmCFtQ4sfke2DHMAtoSazfeZwJwpaX2LzmLTNIq4SAusSjv7ogYREBI4kN
	a/oYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBMfrM+kdjKsaLA4xCnAwKvHwRog6BgqxJpYVV+YeYpTgYFYS4fX0AgrxpiRWVqUW5ccX
	leakFh9iTAb6cyKzlGhyPjCV5JXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUg
	tQhmCxMHp1QDo87xG9y/umctOHjGu4Lb5350dMAhN3dnHpEXfZ/Kp5pv9nZ9fGPi2u8KM0Pe
	hkfWVwo231ja9sp77pmyUx+0mCVP2oR6fynTXjyhdneCQuSU9in7zn1L5PVhXfm11yziaONp
	Ic8dFV+Frqae5fmx/fdTV86gtLsn1rF4XTfxUzz75azkhZQT+kosxRmJhlrMRcWJAGT3GJsb	AwAA
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
 drivers/rtc/rtc-test.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index b92e0f6..7746e65 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -99,8 +99,10 @@ static DEVICE_ATTR(irq, S_IRUGO | S_IWUSR, test_irq_show, test_irq_store);
 static int test_probe(struct platform_device *plat_dev)
 {
 	int err;
-	struct rtc_device *rtc = rtc_device_register("test", &plat_dev->dev,
-						&test_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&plat_dev->dev, "test",
+				&test_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		err = PTR_ERR(rtc);
 		return err;
@@ -115,15 +117,11 @@ static int test_probe(struct platform_device *plat_dev)
 	return 0;
 
 err:
-	rtc_device_unregister(rtc);
 	return err;
 }
 
 static int test_remove(struct platform_device *plat_dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
-
-	rtc_device_unregister(rtc);
 	device_remove_file(&plat_dev->dev, &dev_attr_irq);
 
 	return 0;
-- 
1.7.2.5


