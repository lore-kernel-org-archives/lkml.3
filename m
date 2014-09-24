Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaIXJpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:45:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36795 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbaIXJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:45:30 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Revert "mfd: wm5102: Manually apply register patch"
Date: Wed, 24 Sep 2014 10:37:10 +0100
Message-Id: <1411551431-13045-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit d9d03496f6f904a3588bdb8b215853bc4e50132c.

It seems this commit was applied twice, once through ASoC and once
through MFD:

commit 4c9bb8bc352a14c9613c77bc3f1e9038cd086b9b
mfd: wm5102: Manually apply register patch

commit d9d03496f6f904a3588bdb8b215853bc4e50132c
mfd: wm5102: Manually apply register patch

This has lead to a small piece of duplicate code. It is harmless hence
how it has gone unoticed for so long. This patch reverts one of the two
commits removing the unneeded code.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 4afb232..72b3202 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -393,18 +393,6 @@ static int arizona_runtime_resume(struct device *dev)
 		break;
 	}
 
-	switch (arizona->type) {
-	case WM5102:
-		ret = wm5102_patch(arizona);
-		if (ret != 0) {
-			dev_err(arizona->dev, "Failed to apply patch: %d\n",
-				ret);
-			goto err;
-		}
-	default:
-		break;
-	}
-
 	ret = regcache_sync(arizona->regmap);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to restore register cache\n");
-- 
1.7.2.5

