Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaGHA6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:58:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaGGXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.15 086/122] regulator: tps65218: Add the missing of_node assignment in probe
Date: Mon,  7 Jul 2014 16:57:28 -0700
Message-Id: <20140707235736.838120737@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keerthy <j-keerthy@ti.com>

commit d2fa87c3af0df7ed10463afc588affdab954fa92 upstream.

Add the missing of_node assignment in probe.

Fixes: 90e7d5262796 (regulator: tps65218: Add Regulator driver for TPS65218 PMIC)
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/tps65218-regulator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -257,6 +257,7 @@ static int tps65218_regulator_probe(stru
 	config.init_data = init_data;
 	config.driver_data = tps;
 	config.regmap = tps->regmap;
+	config.of_node = pdev->dev.of_node;
 
 	rdev = devm_regulator_register(&pdev->dev, &regulators[id], &config);
 	if (IS_ERR(rdev)) {


