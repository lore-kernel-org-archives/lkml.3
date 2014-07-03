Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030858AbaGCJvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:51:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965097AbaGCJXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Per Gundberg <per.gundberg@icomera.com>, Wim Van Sebroeck <wim@iguana.be>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/198] watchdog: kempld-wdt: Use the correct value when configuring the prescaler with the watchdog
Date: Thu,  3 Jul 2014 10:19:17 +0100
Message-Id: <1404379241-8590-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: gundberg <per.gundberg@icomera.com>

commit a9e0436b303e94ba57d3bd4b1fcbeaa744b7ebeb upstream.

Use the prescaler index, rather than its value, to configure the watchdog.
This will prevent a mismatch with the prescaler used to calculate the cycles.

Signed-off-by: Per Gundberg <per.gundberg@icomera.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
Tested-by: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

