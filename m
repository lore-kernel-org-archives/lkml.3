Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaBGHzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:55:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18771 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBGHzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:55:17 -0500
X-AuditID: cbfee68f-b7f156d00000276c-37-52f49164ea9a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
In-reply-to: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
Subject: [PATCH 1/4] rtc: rtc-coh901331: Use devm_ioremap_resource()
Date: Fri, 07 Feb 2014 16:55:15 +0900
Message-id: <000501cf23d9$f0057a80$d0106f80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2dGo+e7pmAi4QKyN7t2QoeNN8wAAAW2Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ92UiV+CDA6sEbRYcvEqu8Wc9WvY
	LC4vvMRqMeXPciaLy7vmsFns7+xgdGDz2DPxJJvHnWt72DxOzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CL4rJJSc3JLEst0rdL4MqYuKqNqeAhd8Xlhd/ZGxifc3YxcnJICJhI7Dx9lA3CFpO4cG89
	kM3FISSwjFHi192LbDBFK7Z+ZgKxhQQWMUpcWsMLUfSLUeLrx/9gCTYBNYkvXw6zdzFycIgI
	6Eu0tWiA1DAL7GaUWL/2GCtEs63EwpedzCA2p4CdRP+ePrC4sICLROP8jewgNouAqkTrkRmM
	IDYvUP3MnUuYIGxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHEyqlL
	WSFKRCT2vXjHCHKPhMBHdomOK3tYIXYJSHybfIgFoldWYtMBZoh/JSUOrrjBMoFRYhaSzbOQ
	bJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ3v4djHcPWB9iTAZaP5FZ
	SjQ5Hxj9eSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBMW7TCc9r2vfY3J9ckP3GkFM+R+/Po1VLP3x2WSHivlVC6qqe5hIewXNL/l9lWMrrGnXm
	uJlP1t74vAjfuTG3z/pHvU+q+zR9somtrvAdjhuLL6/ieda7d6v/K7Ud3mXVrC7tGiqmR1Zz
	frNK2VIgfLjt6Ydr5msyphbu2nI3Ium5JrNVXM37LCWW4oxEQy3mouJEAGVeSBj0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd2UiV+CDD428FosuXiV3WLO+jVs
	FpcXXmK1mPJnOZPF5V1z2Cz2d3YwOrB57Jl4ks3jzrU9bB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmLiqjangIXfF5YXf2RsY
	n3N2MXJySAiYSKzY+pkJwhaTuHBvPRuILSSwiFHi0hreLkYuIPsXo8TXj//BitgE1CS+fDnM
	3sXIwSEioC/R1qIBUsMssJtRYv3aY6wQzbYSC192MoPYnAJ2Ev17+sDiwgIuEo3zN7KD2CwC
	qhKtR2Ywgti8QPUzdy5hgrAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIi
	AkYSK6cuZYUoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iRGcGp5J72Bc1WBxiFGAg1GJh/fE0s9BQqyJZcWVuYcYJTiYlUR4fzZ8CRLiTUms
	rEotyo8vKs1JLT7EmAz06ERmKdHkfGDayiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpi
	SWp2ampBahHMFiYOTqkGRq3iRz/00xk4H7w6X/38UDP/zf2mRuFcm45tjZy7zb05obBH9XOQ
	QbRiTzw3/69D/nPv9G/RPPuAL49976YVwfPmh3admaiiXlu1dIfOtRDZ9/Vb992R4WXMEdW9
	NmH3hmuM9eK655+ZOx+NjYuovFbeHOAtocUf8EB48XHHgmNnkn+Zvlr3TYmlOCPRUIu5qDgR
	APxM8glRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-coh901331.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 73f1575..869cae2 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -43,8 +43,6 @@
 struct coh901331_port {
 	struct rtc_device *rtc;
 	struct clk *clk;
-	u32 phybase;
-	u32 physize;
 	void __iomem *virtbase;
 	int irq;
 #ifdef CONFIG_PM_SLEEP
@@ -173,19 +171,9 @@ static int __init coh901331_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
-	rtap->phybase = res->start;
-	rtap->physize = resource_size(res);
-
-	if (devm_request_mem_region(&pdev->dev, rtap->phybase, rtap->physize,
-				    "rtc-coh901331") == NULL)
-		return -EBUSY;
-
-	rtap->virtbase = devm_ioremap(&pdev->dev, rtap->phybase, rtap->physize);
-	if (!rtap->virtbase)
-		return -ENOMEM;
+	rtap->virtbase  = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtap->virtbase))
+		return PTR_ERR(rtap->virtbase);
 
 	rtap->irq = platform_get_irq(pdev, 0);
 	if (devm_request_irq(&pdev->dev, rtap->irq, coh901331_interrupt, 0,
-- 
1.7.10.4


