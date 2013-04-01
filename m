Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3DAR2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:28:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47079 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757602Ab3DAR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 14/15] mfd: wm5102: Deactivate standard boot sequence
Date: Mon,  1 Apr 2013 18:28:11 +0100
Message-Id: <1364837292-30191-14-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

This patch deactivates the standard, currently noop, boot sequence
because we now have facilities in place for running a custom boot
sequence.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 6ca5cfb..26ac372 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -336,12 +336,6 @@ static int arizona_runtime_resume(struct device *dev)
 
 	regcache_cache_only(arizona->regmap, false);
 
-	ret = arizona_wait_for_boot(arizona);
-	if (ret != 0) {
-		regulator_disable(arizona->dcvdd);
-		return ret;
-	}
-
 	switch (arizona->type) {
 	case WM5102:
 		ret = wm5102_patch(arizona);
@@ -360,6 +354,11 @@ static int arizona_runtime_resume(struct device *dev)
 		}
 		break;
 	default:
+		ret = arizona_wait_for_boot(arizona);
+		if (ret != 0) {
+			goto err;
+		}
+
 		break;
 	}
 
-- 
1.7.10.4

