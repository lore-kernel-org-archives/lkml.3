Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaDROrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:47:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19889 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDROrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:47:39 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-0a-53513b0900b9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] extcon: max14577: Properly handle regmap_irq_get_virq error
Date: Fri, 18 Apr 2014 16:47:30 +0200
Message-id: <1397832450-5086-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJMWRmVeSWpSXmKPExsVy+t/xa7qc1oHBBk2XDCyuf3nOavH6haHF
	5V1z2CxuN65gs1iw8RGjA6tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZew+uYS5oJGt4v4j
	1gbGJtYuRk4OCQETiXkvpjBC2GISF+6tZ+ti5OIQEljKKLH71yJmCKePSWLxvpNgHWwCxhKb
	ly9hA7FFBAolnmy4CmYzC3hKvPv7kB3EFhbwkeh/+oepi5GDg0VAVWLybxWQMK+Am8THVV+Z
	IJYpSCz7spZ5AiP3AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh/v66g3HpMatDjAIc
	jEo8vBe++gcLsSaWFVfmHmKU4GBWEuHd/TcgWIg3JbGyKrUoP76oNCe1+BAjEwenVAOj+LT6
	QOdvxZdPiH6PjhRlWB6VrnbCgfn2ysTQ62fs7JxdVS7ZPGha9GdG6EOzLLOlm150ezW8ehjh
	x3VVdvXivz2fE16pXth0Qejt0zS728ejRAJT8/6+8Nl3j/fb93+cs08vMf+Rs2f/AtuuXPVP
	boH8v6rDThk6zzhzY6di0CfxuB+nFv7KUWIpzkg01GIuKk4EAGcbmRHVAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_irq_get_virq may return 0 or -EINVAL on error. Fail the probe
in both situations.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
---
 drivers/extcon/extcon-max14577.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 3846941801b8..d58747d2ddfa 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -650,7 +650,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		unsigned int virq = 0;
 
 		virq = regmap_irq_get_virq(max14577->irq_data, muic_irq->irq);
-		if (!virq)
+		if (virq <= 0)
 			return -EINVAL;
 		muic_irq->virq = virq;
 
-- 
1.8.3.2

