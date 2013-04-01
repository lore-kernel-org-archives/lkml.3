Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab3DAR2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:28:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47082 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757547Ab3DAR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 09/15] mfd: arizona: Unconditionally enable 32kHz clock
Date: Mon,  1 Apr 2013 18:28:06 +0100
Message-Id: <1364837292-30191-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have a directly provided 32kHz clock unconditionally enable it,
substantial chip functionality relies on it so dynamic management is
not worthwhile.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index f8ffc3e..33ddc11 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -515,6 +515,7 @@ int arizona_dev_init(struct arizona *arizona)
 		regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
 				   ARIZONA_CLK_32K_SRC_MASK,
 				   arizona->pdata.clk32k_src - 1);
+		arizona_clk32k_enable(arizona);
 		break;
 	case ARIZONA_32KZ_NONE:
 		regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
-- 
1.7.10.4

