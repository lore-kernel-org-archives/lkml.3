Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab3E3RB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:01:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:32585 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758402Ab3E3RBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:01:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="345807957"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 2/2] regmap: fix return of uninitialized value
Date: Thu, 30 May 2013 21:54:02 +0530
Message-Id: <1369931042-9755-2-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369931042-9755-1-git-send-email-vinod.koul@intel.com>
References: <1369931042-9755-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 7989052..1db02cd 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -80,7 +80,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 {
 	struct regmap_debugfs_off_cache *c = NULL;
 	loff_t p = 0;
-	unsigned int i, ret;
+	unsigned int i, ret = 0;
 	unsigned int fpos_offset;
 	unsigned int reg_offset;
 
-- 
1.7.0.4

