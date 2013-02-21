Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3BUIgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:36:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45550 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3BUIgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:36:12 -0500
X-AuditID: cbfee68e-b7fc26d000001938-2c-5125dc7a49e6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 08/12] rtc: rtc-da9052: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:36:09 +0900
Message-id: <00d301ce100e$7fced110$7f6c7330$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAIA7Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zfd2qO6qBBod6FS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGl2V7WAp28VZs7OZtYGzn7mLk5JAQMJF4PvcBM4QtJnHh3nq2
	LkYuDiGBZYwSf5beBEpwgBX9vWoIEV/EKPFm2h52CGc2k8Tbn9NZQLrZBNQkvnw5zA7SICKg
	L9HWogFSwyzQyyhxpnc3O0iNkICtxJwP18C2cQrYSVze9oUVxBYWcJf40zgJbA6LgKrElhs3
	WEDm8ALVtx6sAgnzCghK/Jh8D6yEWUBLYv3O40wQtrzE5jVvoe5Ul3j0VxckLCJgJLFwwTWo
	EhGJfS/eMYKcIyGwjF3i0a5/7BCrBCS+TT7EAtErK7HpADQcJCUOrrjBMoFRYhaSzbOQbJ6F
	ZPMsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJqr4djDcPWB9iTAZaP5FZSjQ5
	HxiVeSXxhsbGJmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WHHw1v31kTW8D6O2JafKtSRreH44PTVlY1fVfeGgp63WGSwvXZ8Gc+r5KhR33Hh7qklr1gyJ
	vG3Xeae5v1vDPv2q1bqgnX+3daUkXztZPs1z51K35Tr7sm9q6PDMLkktNE/mtTCQcN39/lNw
	Cu8lm38T/WYt+M5nY/KUoTRRNHuNk37lwtPxSizFGYmGWsxFxYkAd1l8G8ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG7VHdVAgy/XpS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpdle1gKdvFWbOzmbWBs
	5+5i5OCQEDCR+HvVsIuRE8gUk7hwbz1bFyMXh5DAIkaJN9P2sEM4s5kk3v6czgJSxSagJvHl
	y2F2kGYRAX2JthYNkBpmgV5GiTO9u9lBaoQEbCXmfLjGDGJzCthJXN72hRXEFhZwl/jTOAls
	DouAqsSWGzdYQObwAtW3HqwCCfMKCEr8mHwPrIRZQEti/c7jTBC2vMTmNW+ZIW5Wl3j0Vxck
	LCJgJLFwwTWoEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWl
	eel6yfm5mxjBMftMagfjygaLQ4wCHIxKPLwLXqoECrEmlhVX5h5ilOBgVhLhVbytGijEm5JY
	WZValB9fVJqTWnyIMRnoz4nMUqLJ+cB0klcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJ
	JanZqakFqUUwW5g4OKUaGC+suxuUvWu34jkmGUPlbYbGYWu4OadVf4qvyBdznvRienD7knT2
	Mg+JC68WrZRKbE+ziDEPuuQewNC0s3NVxeVYpmm6ahOYmubNjYoPWNDekFOh+UFOc2P6nblz
	ORm82O8uSmoMF2qd3mbbKms945Pf0epvvR5mPzIbIn1uK+0+f29Xy/u7SizFGYmGWsxFxYkA
	ymq0VR0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-da9052.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 60b826e..0dde688 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -240,9 +240,10 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
 	rtc->irq = platform_get_irq_byname(pdev, "ALM");
-	ret = request_threaded_irq(rtc->irq, NULL, da9052_rtc_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "ALM", rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				da9052_rtc_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"ALM", rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
 		return ret;
@@ -250,16 +251,10 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				       &da9052_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc->rtc)) {
-		ret = PTR_ERR(rtc->rtc);
-		goto err_free_irq;
-	}
+	if (IS_ERR(rtc->rtc))
+		return PTR_ERR(rtc->rtc);
 
 	return 0;
-
-err_free_irq:
-	free_irq(rtc->irq, rtc);
-	return ret;
 }
 
 static int da9052_rtc_remove(struct platform_device *pdev)
@@ -267,7 +262,6 @@ static int da9052_rtc_remove(struct platform_device *pdev)
 	struct da9052_rtc *rtc = pdev->dev.platform_data;
 
 	rtc_device_unregister(rtc->rtc);
-	free_irq(rtc->irq, rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


