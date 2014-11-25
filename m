Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaKYMEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:04:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaKYKkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 014/254] regulator: max77693: Fix use of uninitialized regulator config
Date: Tue, 25 Nov 2014 10:36:04 +0000
Message-Id: <1416912004-5928-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit ca0c37a0b489bb14bf3e1549e7a8d0c9a17f4919 upstream.

Driver allocated on stack struct regulator_config but didn't initialize
it fully. Few fields (driver_data, ena_gpio) were left untouched. This
lead to using random ena_gpio values as GPIOs for max77693 regulators.

On occasion these values could match real GPIO numbers leading to
interfering with other drivers and to unsuccessful enable/disable of
regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 80b022e29bfd ("regulator: max77693: Add max77693 regualtor driver.")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/regulator/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 653a58b49cdf..ddd67b89006c 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -227,7 +227,7 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	struct max77693_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max77693_regulator_data *rdata = NULL;
 	int num_rdata, i;
-	struct regulator_config config;
+	struct regulator_config config = { };
 
 	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
 	if (!rdata || num_rdata <= 0) {
-- 
2.1.0

