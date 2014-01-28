Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaA1MWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:22:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32551 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaA1MTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:08 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-f8-52e7a03b7395
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
Date: Tue, 28 Jan 2014 13:18:35 +0100
Message-id: <1390911522-28209-12-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4NV3rBc+DDGafk7OY+vAJm8X1L89Z
	LV6/MLQ42/SG3eL+16OMFt+udDBZbHp8jdXi8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfGyRnTWArm8Ves
	6JNtYLzC08XIySEhYCIx79UuFghbTOLCvfVsXYxcHEICSxkljn/fA+X0MUm8eH2IDaSKTcBY
	YvPyJWAJEYHVTBJrFkwFa2cW6GWUuLnbA8QWFvCUuPT0ITOIzSKgKvGobRE7iM0r4CHR8vYB
	axcjB9A6BYk5k2xAwpxA4VdXG5lAbCEBd4lTx9+xTGDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4
	NC9dLzk/dxMjJBC/7mBceszqEKMAB6MSD++D7mdBQqyJZcWVuYcYJTiYlUR4E2c/DxLiTUms
	rEotyo8vKs1JLT7EyMTBKdXAuDj5Y93F63mSaj/uRD/iavgU+TRT9vOOQp5LW/NmLdz/vdtg
	akferB8t63lkmXgT4uVv1fzkfxJecbDnIGfm75Nfl3zqTZh8V/Z8nrbP9zO9ZrNtE3xZAhf2
	L9X8nchh6b556ttrjxplmOVFG1/llHbuYeGwcX4jajnprcqLcp+yTg6v/74xSizFGYmGWsxF
	xYkA55YnviICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add max14577 prefix to muic_irqs array. This prepares for max77836
support in this extcon driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
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

