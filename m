Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966927Ab3DQP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:58:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966805Ab3DQP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:58:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] mfd: wm5102: Manually apply register patch
Date: Wed, 17 Apr 2013 16:58:33 +0100
Message-Id: <1366214315-29032-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366214315-29032-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130417155815.GA13687@opensource.wolfsonmicro.com>
 <1366214315-29032-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Future updates will require us to manually apply the register patch for
wm5102.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 81907f9..f713a1d 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -368,6 +368,16 @@ static int arizona_runtime_resume(struct device *dev)
 		break;
 	}
 
+	switch (arizona->type) {
+	case WM5102:
+		ret = wm5102_patch(arizona);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to apply patch: %d\n",
+				ret);
+			goto err;
+		}
+	}
+
 	ret = regcache_sync(arizona->regmap);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to restore register cache\n");
-- 
1.7.10.4

