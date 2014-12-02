Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbaLBT0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbaLBT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 023/121] regulator: max77693: Fix use of uninitialized regulator config
Date: Tue,  2 Dec 2014 11:18:22 -0800
Message-Id: <1417548000-1794-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/regulator/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index feb20bf..c2725e4 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -231,7 +231,7 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	struct max77693_pmic_dev *max77693_pmic;
 	struct max77693_regulator_data *rdata = NULL;
 	int num_rdata, i;
-	struct regulator_config config;
+	struct regulator_config config = { };
 
 	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
 	if (!rdata || num_rdata <= 0) {
-- 
1.9.1

