Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaKRORK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:17:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbaKROK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 199/206] regulator: max77693: Fix use of uninitialized regulator config
Date: Tue, 18 Nov 2014 15:09:14 +0100
Message-Id: <7f7ae192a6d6472d06a2d5a05daba04ce9facc43.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/regulator/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index ce4b96c15eba..85a54b39e3b7 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -231,7 +231,7 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	struct max77693_pmic_dev *max77693_pmic;
 	struct max77693_regulator_data *rdata = NULL;
 	int num_rdata, i, ret;
-	struct regulator_config config;
+	struct regulator_config config = { };
 
 	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
 	if (!rdata || num_rdata <= 0) {
-- 
2.1.3

