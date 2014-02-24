Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBXKLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:11:32 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaBXKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-46-530b1ac387ea
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 06/16] extcon: max14577: Add max14577 prefix to muic_irqs
Date: Mon, 24 Feb 2014 11:10:31 +0100
Message-id: <1393236641-14977-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xy7qHpbiDDaYu07bYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJbnO5mtVg/
	4zWLA6/Hzll32T02r9Dy2LSqk83jzrU9bB7zTgZ6bF5S79G3ZRWjx+dNcgEcUVw2Kak5mWWp
	Rfp2CVwZS++HFvznr9g9YR5jA+Nq3i5GTg4JAROJf5PeskDYYhIX7q1n62Lk4hASWMoocXXC
	aUYIp49J4tb9f6wgVWwCxhKbly8BqxIR2MIk0fvhC1gVs8BzRomPi2ayg1QJC/hI3Nj8BayD
	RUBVYkbnbTYQm1fAXWLV2mVAcQ6gfQoScybZgIQ5BTwk7rY8ACsXAir5Nu86ywRG3gWMDKsY
	RVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsL0yw7GxcesDjEKcDAq8fBKVHMFC7EmlhVX5h5i
	lOBgVhLhNePlDhbiTUmsrEotyo8vKs1JLT7EyMTBKdXAaHRe8VFHne4NF4sF8j/qX7521vFc
	c/nKrB8s/0Q4v1bH21ybZzZ9kpFC/3/rC8Ii7TzKOzSb3l7uuVKc7FAgeeVn+PHVe+ovatvF
	XuvJX179bVNMxpIyryzpJu13BaUC0o4Hm+uru5gEjrgmPWy9Efn6+IqZMU8eHi3493cy72xm
	67e+r+eGKLEUZyQaajEXFScCAOLXuoQxAgAA
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

