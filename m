Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaIXQrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:49517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaIXQrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749504"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Grant Grundler <grundler@chromium.org>, linux-mmc@vger.kernel.org
Subject: [PATCH 14/27] mmc: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:04 +0530
Message-Id: <1411575342-31048-15-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/mmc/core/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d03a080..5081089 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -954,8 +954,7 @@ EXPORT_SYMBOL(mmc_get_card);
 void mmc_put_card(struct mmc_card *card)
 {
 	mmc_release_host(card->host);
-	pm_runtime_mark_last_busy(&card->dev);
-	pm_runtime_put_autosuspend(&card->dev);
+	pm_runtime_last_busy_and_autosuspend(&card->dev);
 }
 EXPORT_SYMBOL(mmc_put_card);
 
-- 
1.7.0.4

