Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3AKNNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:13:46 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:55841 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab3AKNNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:44 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/18] power: ab8500_btemp: remove superfluous BTEMP thermal comp.
Date: Fri, 11 Jan 2013 13:13:00 +0000
Message-Id: <1357909986-9262-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

BTEMP thermal compensation factor times 10 is applied in two
places, probe and get_property. Removed from probe.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/ab8500_btemp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 6f6a715..c882a9a 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1030,8 +1030,8 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 		ab8500_btemp_periodic_work);
 
 	/* Set BTEMP thermal limits. Low and Med are fixed */
-	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT * 10;
-	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT * 10;
+	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT;
+	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT;
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
 		AB8500_BTEMP_HIGH_TH, &val);
-- 
1.7.9.5

