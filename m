Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbaKLBs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:48:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965548AbaKLBsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:48:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.14 198/203] regulator: max77693: Fix use of uninitialized regulator config
Date: Wed, 12 Nov 2014 10:17:48 +0900
Message-Id: <20141112011551.777054000@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/max77693.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -232,7 +232,7 @@ static int max77693_pmic_probe(struct pl
 	struct max77693_pmic_dev *max77693_pmic;
 	struct max77693_regulator_data *rdata = NULL;
 	int num_rdata, i;
-	struct regulator_config config;
+	struct regulator_config config = { };
 
 	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
 	if (!rdata || num_rdata <= 0) {


