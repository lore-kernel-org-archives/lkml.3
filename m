Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab3DCSFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:05:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53537 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762994Ab3DCSF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:05:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: arizona: Wait for internal clocks to startup after reset
Date: Wed,  3 Apr 2013 19:05:20 +0100
Message-Id: <1365012321-7673-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365012321-7673-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130403180423.GA6985@opensource.wolfsonmicro.com>
 <1365012321-7673-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index e4c8dc2..69e9796 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -519,8 +519,10 @@ int arizona_dev_init(struct arizona *arizona)
 		goto err_enable;
 	}
 
-	if (arizona->pdata.reset)
+	if (arizona->pdata.reset) {
 		gpio_set_value_cansleep(arizona->pdata.reset, 1);
+		msleep(1);
+	}
 
 	regcache_cache_only(arizona->regmap, false);
 
@@ -579,6 +581,8 @@ int arizona_dev_init(struct arizona *arizona)
 			goto err_reset;
 		}
 
+		msleep(1);
+
 		ret = regcache_sync(arizona->regmap);
 		if (ret != 0) {
 			dev_err(dev, "Failed to sync device: %d\n", ret);
-- 
1.7.10.4

