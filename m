Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaBQJHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:07:31 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34205 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaBQJGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:06:23 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-7a-5301d1026634
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 06/15] extcon: max14577: Add max14577 prefix to muic_irqs
Date: Mon, 17 Feb 2014 10:05:41 +0100
Message-id: <1392627950-26927-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t/xa7pMFxmDDZZesrTYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJb3G5cwWZx
	upvVYv2M1ywOfB47Z91l99i8Qstj06pONo871/awecw7GeixeUm9R9+WVYwenzfJBXBEcdmk
	pOZklqUW6dslcGUsvR9a8J+/YveEeYwNjKt5uxg5OSQETCSmfFrEBmGLSVy4tx7MFhJYyijx
	s7m8i5ELyO5jkli87htYgk3AWGLz8iVsIAkRgRYmiffr9zOCOMwCh5gkFty4wQxSJSzgIzHx
	znVWEJtFQFXi0JcnjCA2r4C7xL8Ve4BsDqB1ChJzJtmAhDkFPCRuLr3FDrHZXeLJox0sExh5
	FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICdcvOxgXH7M6xCjAwajEw2tQzRgsxJpY
	VlyZe4hRgoNZSYTXdh1QiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Ojv8qRDwuOsrY1VusZStQs
	+VS8dsMODv6GPcFvwrbLiqmfl2uId/J54Lbyz4ElxhyPfU+s2Pfsr+dEZeGfL7RZv92+so69
	eprCZ+s9N+8+T937ztSa42+02NzTpWzij0xvsRXMs74weavQr4PWC3g8ZRt5johZpSbYx3Vb
	Cbz58bHh/wSGa5pKLMUZiYZazEXFiQDIkt9ENQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add max14577 prefix to muic_irqs array. This prepares for max77836
support in this extcon driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index fd48b4909470..fb343f4042d2 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -85,7 +85,7 @@ struct max14577_muic_irq {
 	unsigned int virq;
 };
 
-static struct max14577_muic_irq muic_irqs[] = {
+static struct max14577_muic_irq max14577_muic_irqs[] = {
 	{ MAXIM_IRQ_INT1_ADC,		"muic-ADC" },
 	{ MAXIM_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
 	{ MAXIM_IRQ_INT1_ADCERR,	"muic-ADCError" },
@@ -541,9 +541,9 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
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
 	case MAXIM_IRQ_INT1_ADC:
@@ -647,8 +647,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
 
 	/* Support irq domain for max14577 MUIC device */
-	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
-		struct max14577_muic_irq *muic_irq = &muic_irqs[i];
+	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++) {
+		struct max14577_muic_irq *muic_irq = &max14577_muic_irqs[i];
 		unsigned int virq = 0;
 
 		virq = regmap_irq_get_virq(maxim_core->irq_data_muic,
-- 
1.7.9.5

