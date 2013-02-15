Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161685Ab3BOMxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:53:48 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53274 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161408Ab3BOMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:20 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/40] ab8500-fg: Allow capacity to raise from 1% when charging
Date: Fri, 15 Feb 2013 12:44:47 +0000
Message-Id: <1360932310-30065-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

When battery capacity was going below 1% fg is not supposed
to report 0% unless we've got the LOW_BAT IRQ, no matter
what the FG-algorithm says. This made fg get stuck at 1% if
charger is connected when capacity is 1%.

Signed-off-by: Hakan BERG <hakan.berg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
---
 drivers/power/ab8500_fg.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 44d8faa..f596883 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1354,9 +1354,6 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 			 * algorithm says.
 			 */
 			di->bat_cap.prev_percent = 1;
-			di->bat_cap.permille = 1;
-			di->bat_cap.prev_mah = 1;
-			di->bat_cap.mah = 1;
 			percent = 1;
 
 			changed = true;
@@ -1768,9 +1765,10 @@ static void ab8500_fg_algorithm(struct ab8500_fg *di)
 			ab8500_fg_algorithm_discharging(di);
 	}
 
-	dev_dbg(di->dev, "[FG_DATA] %d %d %d %d %d %d %d %d %d "
+	dev_dbg(di->dev, "[FG_DATA] %d %d %d %d %d %d %d %d %d %d "
 		"%d %d %d %d %d %d %d\n",
 		di->bat_cap.max_mah_design,
+		di->bat_cap.max_mah,
 		di->bat_cap.mah,
 		di->bat_cap.permille,
 		di->bat_cap.level,
-- 
1.7.10.4

