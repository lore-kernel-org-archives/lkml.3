Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaBQJGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:06:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34205 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaBQJGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:06:09 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-69-5301d0fe649d
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
Subject: [PATCH v3 01/15] extcon: max14577: Change extcon name instead of
 static name according to device type
Date: Mon, 17 Feb 2014 10:05:36 +0100
Message-id: <1392627950-26927-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t/xa7r/LjAGG/SdNLPYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJb3G5cwWZx
	upvVYv2M1ywOfB47Z91l99i8Qstj06pONo871/awecw7GeixeUm9R9+WVYwenzfJBXBEcdmk
	pOZklqUW6dslcGX8W3uFpeAwb8X3FzeYGhi3cXcxcnBICJhITNgg2cXICWSKSVy4t56ti5GL
	Q0hgKaPE0da77BBOH5PE5q77zCBVbALGEpuXLwGrEhFoYZJ4v34/I4jDLHCISWLBjRtgVcIC
	BRIL1lxgB7FZBFQlVp5rBLN5BdwlVp95yw6xWkFiziQbkDCngIfEzaW3wEqEgEqePNrBMoGR
	dwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkID9soNx8TGrQ4wCHIxKPLwG1YzBQqyJ
	ZcWVuYcYJTiYlUR4bdcBhXhTEiurUovy44tKc1KLDzEycXBKNTBOs+/5dDeFneV23JMD4pME
	/vcUti1ZPDmmoH7RUX8uq/9184JiRIo/z7vC/ripk2nN9+CZ0+5eFTjc1anRLOC5z6x3z7Et
	Gp7HBUyXmpZuvMwaYxwhwyIQ8XuhHetioc1cqT8vVS/dEhN3q6DG9sGK6urnp1uKdp7hPTHt
	Y86H1PCMRokX798psRRnJBpqMRcVJwIAknhxNjYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch use device name to make sysfs path according to device type:

max14577-muic
- /sys/class/extcon/max14577-muic/
max77836-muic
- /sys/class/extcon/max77836-muic/

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 3846941801b8..59f084fee4f3 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -24,7 +24,6 @@
 #include <linux/mfd/max14577-private.h>
 #include <linux/extcon.h>
 
-#define	DEV_NAME			"max14577-muic"
 #define	DELAY_MS_DEFAULT		17000		/* unit: millisecond */
 
 enum max14577_muic_adc_debounce_time {
@@ -673,7 +672,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		return -ENOMEM;
 	}
-	info->edev->name = DEV_NAME;
+
+	info->edev->name = dev_name(&pdev->dev);
 	info->edev->supported_cable = max14577_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
@@ -737,7 +737,7 @@ static int max14577_muic_remove(struct platform_device *pdev)
 
 static struct platform_driver max14577_muic_driver = {
 	.driver		= {
-		.name	= DEV_NAME,
+		.name	= "max14577-muic",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max14577_muic_probe,
-- 
1.7.9.5

