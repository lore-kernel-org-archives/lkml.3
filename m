Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaIXJph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:45:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36796 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbaIXJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:45:30 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: arizona: Correct mask to allow setting micbias external cap
Date: Wed, 24 Sep 2014 10:37:11 +0100
Message-Id: <1411551431-13045-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1411551431-13045-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1411551431-13045-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the mask for the external capacitor bit is missing when
writing the MICBIAS config meaning it will never be set this patch fixes
this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 72b3202..bce7c07 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -947,6 +947,7 @@ int arizona_dev_init(struct arizona *arizona)
 		regmap_update_bits(arizona->regmap,
 				   ARIZONA_MIC_BIAS_CTRL_1 + i,
 				   ARIZONA_MICB1_LVL_MASK |
+				   ARIZONA_MICB1_EXT_CAP |
 				   ARIZONA_MICB1_DISCH |
 				   ARIZONA_MICB1_BYPASS |
 				   ARIZONA_MICB1_RATE, val);
-- 
1.7.2.5

