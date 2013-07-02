Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3GBW7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:59:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36196 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3GBW7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:59:05 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Daniel Jeong <gshark.jeong@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Tue,  2 Jul 2013 23:58:38 +0100
Message-Id: <1372805918-15128-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: lp8755: Provide map_voltage()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Improve performance when setting voltages by avoiding a scan through the
selectors when we can simply calculate the selector we want.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/lp8755.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index d9e38b4..b37ef30 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -228,6 +228,7 @@ err_i2c:
 }
 
 static struct regulator_ops lp8755_buck_ops = {
+	.map_voltage = regulator_map_voltage_linear,
 	.list_voltage = regulator_list_voltage_linear,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-- 
1.8.3.1

