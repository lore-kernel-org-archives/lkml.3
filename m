Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaJ0Q0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:26:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37649 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaJ0QXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:23:51 -0400
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: devicetree@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com, johan@kernel.org, linux-pm@vger.kernel.org,
        linux@roeck-us.net, lee.jones@linaro.org, balbi@ti.com,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: [PATCH v1 03/10] regulator: act8865: Use of_is_system_power_controller helper function
Date: Mon, 27 Oct 2014 16:26:48 +0000
Message-Id: <1414427215-14380-3-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/regulator/act8865-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index 76301ed..435aba1 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -365,7 +365,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	if (of_system_has_poweroff_source(dev->of_node)) {
+	if (of_is_system_power_controller(dev->of_node)) {
 		if (!pm_power_off) {
 			act8865_i2c_client = client;
 			act8865->off_reg = off_reg;
-- 
1.9.1

