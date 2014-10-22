Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaJVPXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:23:24 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43104 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaJVPXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:23:22 -0400
From: Romain Perier <romain.perier@gmail.com>
To: sameo@linux.intel.com
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        broonie@kernel.org
Subject: [PATCH v1 1/5] mfd: tps65910: Convert ti,system-power-controller DT property to poweroff-source
Date: Wed, 22 Oct 2014 15:26:23 +0000
Message-Id: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer use custom property to define poweroff capability, use the standard
DT property instead.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/mfd/tps65910.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 7612d89..b8dca8a 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -423,8 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 
 	board_info->irq = client->irq;
 	board_info->irq_base = -1;
-	board_info->pm_off = of_property_read_bool(np,
-			"ti,system-power-controller");
+	board_info->pm_off = of_system_has_poweroff_source(np);
 
 	return board_info;
 }
-- 
1.9.1

