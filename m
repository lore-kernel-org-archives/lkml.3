Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161349Ab3BOMp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:58 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33131 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161312Ab3BOMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com,
        Martin Bergstrom <martin.bergstrom@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/40] ab8500-fg: Report unscaled capacity
Date: Fri, 15 Feb 2013 12:44:35 +0000
Message-Id: <1360932310-30065-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Bergstrom <martin.bergstrom@stericsson.com>

Unscaled capacity should be reported for POWER_SUPPLY_PROP_CAPACITY.

Signed-off-by: Martin Bergstrom <martin.bergstrom@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 9d33546..44d8faa 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2153,9 +2153,7 @@ static int ab8500_fg_get_property(struct power_supply *psy,
 			val->intval = di->bat_cap.prev_mah;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		if (di->bm->capacity_scaling)
-			val->intval = di->bat_cap.cap_scale.scaled_cap;
-		else if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
+		if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = 100;
 		else
-- 
1.7.10.4

