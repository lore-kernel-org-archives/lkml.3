Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3G3Lqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:46:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38672 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3G3Lqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:46:42 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Chris Ball <cjb@laptop.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Tue, 30 Jul 2013 12:46:14 +0100
Message-Id: <1375184777-25404-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375184777-25404-1-git-send-email-broonie@kernel.org>
References: <1375184777-25404-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/5] mmc: core: Indicate that vmmcq may be absent
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Use regulator_get_optional() to tell the core that requests for the vmmcq
regulator can fail in a real system.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mmc/core/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 49a5bca..5d08855 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1313,7 +1313,7 @@ int mmc_regulator_get_supply(struct mmc_host *mmc)
 
 	supply = devm_regulator_get(dev, "vmmc");
 	mmc->supply.vmmc = supply;
-	mmc->supply.vqmmc = devm_regulator_get(dev, "vqmmc");
+	mmc->supply.vqmmc = devm_regulator_get_optional(dev, "vqmmc");
 
 	if (IS_ERR(supply))
 		return PTR_ERR(supply);
-- 
1.8.3.2

