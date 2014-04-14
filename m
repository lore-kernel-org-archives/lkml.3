Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaDNJTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:19:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54678 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaDNJRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:40 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-43-534ba7af6c45
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 4/9] extcon: max14577: Add max14577 prefix to muic_irqs
Date: Mon, 14 Apr 2014 11:17:15 +0200
Message-id: <1397467040-30502-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Fd31y72DDW6vN7bYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAldH76wVbwQP+isfn7jI2
	ME7m7WLk4JAQMJHo3lHfxcgJZIpJXLi3nq2LkYtDSGApo8T/GYcZIZw+JonGtW/YQarYBIwl
	Ni9fAlYlItDMJNHSdxasilngKKPE9N63TCBjhQW8JL6d5wQxWQRUJWZPtgLp5RVwl1h26iEr
	xDYFiWVf1jKD2JwCHhK3uo+B2UJANS8+3WafwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpe
	cn7uJkZIAH7Zwbj4mNUhRgEORiUe3s453sFCrIllxZW5hxglOJiVRHi3ZXgFC/GmJFZWpRbl
	xxeV5qQWH2Jk4uCUamCcEakkWL1Aer+G5rOU5bImSU5s3yI+v94d454aaxdiye9Vkf7mz9PP
	gsZ5mnmvrBT/RCtsD5SMbtty5pCUw7lrwVtCdfaErLB8M7fX/EuO6oVFZVXTTk2LTPbbGfnz
	1cfAUP3PVz/K1MS52+f3nihjUb326bBlVD7X+6MFltGbdqe3GDX1JCmxFGckGmoxFxUnAgDf
	WxaPHgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add max14577 prefix to muic_irqs array. This prepares for max77836
support in this extcon driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 59f084fee4f3..6f921b7c3e5b 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -85,7 +85,7 @@ struct max14577_muic_irq {
 	unsigned int virq;
 };
 
-static struct max14577_muic_irq muic_irqs[] = {
+static struct max14577_muic_irq max14577_muic_irqs[] = {
 	{ MAX14577_IRQ_INT1_ADC,	"muic-ADC" },
 	{ MAX14577_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
 	{ MAX14577_IRQ_INT1_ADCERR,	"muic-ADCError" },
@@ -538,9 +538,9 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
 	 * However we only need to know whether it was ADC, charger
 	 * or both interrupts so decode IRQ and turn on proper flags.
 	 */
-	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
-		if (irq == muic_irqs[i].virq)
-			irq_type = muic_irqs[i].irq;
+	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++)
+		if (irq == max14577_muic_irqs[i].virq)
+			irq_type = max14577_muic_irqs[i].irq;
 
 	switch (irq_type) {
 	case MAX14577_IRQ_INT1_ADC:
@@ -644,8 +644,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
 
 	/* Support irq domain for max14577 MUIC device */
-	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
-		struct max14577_muic_irq *muic_irq = &muic_irqs[i];
+	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++) {
+		struct max14577_muic_irq *muic_irq = &max14577_muic_irqs[i];
 		unsigned int virq = 0;
 
 		virq = regmap_irq_get_virq(max14577->irq_data, muic_irq->irq);
-- 
1.8.3.2

