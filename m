Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaKULAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:00:38 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:47759 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaKULAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:00:35 -0500
From: Johan Hovold <johan@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, heiko@sntech.de,
        grant.likely@linaro.org, robh@kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, mark.rutland@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        Romain Perier <romain.perier@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH] Revert "mfd: tps65910: Convert ti,system-power-controller DT property to poweroff-source"
Date: Fri, 21 Nov 2014 12:00:16 +0100
Message-Id: <1416567616-10582-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20141121105951.GA20679@localhost>
References: <20141121105951.GA20679@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 25f833c1171d ("mfd: tps65910: Convert
ti,system-power-controller DT property to poweroff-source"), which
switched to a new device-tree property name for configuring the device
as a power-off controller, but failed to update the affected device-tree
sources and neither provided backward compatibility with the old
property name.

This fixes broken power-off functionality for all boards relying on
tps65910 to power off the system.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/mfd/tps65910.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index b8dca8a0db41..7612d89850dd 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -423,7 +423,8 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 
 	board_info->irq = client->irq;
 	board_info->irq_base = -1;
-	board_info->pm_off = of_system_has_poweroff_source(np);
+	board_info->pm_off = of_property_read_bool(np,
+			"ti,system-power-controller");
 
 	return board_info;
 }
-- 
2.0.4

