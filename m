Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3DAR2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:28:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47073 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757028Ab3DAR2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/15] mfd: arizona: Clarify error message for failed primary IRQ request
Date: Mon,  1 Apr 2013 18:27:59 +0100
Message-Id: <1364837292-30191-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap has a very similar looking error, help identify where the error
comes from by changing the error message.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 846262c..0aa39e2 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -264,7 +264,7 @@ int arizona_irq_init(struct arizona *arizona)
 				   flags, "arizona", arizona);
 
 	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to request IRQ %d: %d\n",
+		dev_err(arizona->dev, "Failed to request primary IRQ %d: %d\n",
 			arizona->irq, ret);
 		goto err_main_irq;
 	}
-- 
1.7.10.4

