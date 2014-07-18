Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbaGRNQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:16:08 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17862 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935106AbaGRNQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gundberg <per.gundberg@icomera.com>,
        Wim Van Sebroeck <wim@iguana.be>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/170] watchdog: kempld-wdt: Use the correct value when configuring the prescaler with the watchdog
Date: Fri, 18 Jul 2014 14:10:30 +0200
Message-Id: <ec03435f8102baf52e783b72d11359f8d31f3629.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: gundberg <per.gundberg@icomera.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a9e0436b303e94ba57d3bd4b1fcbeaa744b7ebeb upstream.

Use the prescaler index, rather than its value, to configure the watchdog.
This will prevent a mismatch with the prescaler used to calculate the cycles.

Signed-off-by: Per Gundberg <per.gundberg@icomera.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
Tested-by: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/watchdog/kempld_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/kempld_wdt.c b/drivers/watchdog/kempld_wdt.c
index 5c3d4df63e68..22b9a036b3e1 100644
--- a/drivers/watchdog/kempld_wdt.c
+++ b/drivers/watchdog/kempld_wdt.c
@@ -163,7 +163,7 @@ static int kempld_wdt_set_stage_timeout(struct kempld_wdt_data *wdt_data,
 	kempld_get_mutex(pld);
 	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->id));
 	stage_cfg &= ~STAGE_CFG_PRESCALER_MASK;
-	stage_cfg |= STAGE_CFG_SET_PRESCALER(prescaler);
+	stage_cfg |= STAGE_CFG_SET_PRESCALER(PRESCALER_21);
 	kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->id), stage_cfg);
 	kempld_write32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->id),
 			stage_timeout);
-- 
2.0.0

