Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3DAR2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:28:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47071 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756986Ab3DAR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 01/15] mfd: arizona: Disable all wake sources by default
Date: Mon,  1 Apr 2013 18:27:58 +0100
Message-Id: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130401172748.GG18636@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 2bec5f0..846262c 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -192,6 +192,9 @@ int arizona_irq_init(struct arizona *arizona)
 		return -EINVAL;
 	}
 
+	/* Disable all wake sources by default */
+	regmap_write(arizona->regmap, ARIZONA_WAKE_CONTROL, 0);
+
 	if (arizona->pdata.irq_active_high) {
 		ret = regmap_update_bits(arizona->regmap, ARIZONA_IRQ_CTRL_1,
 					 ARIZONA_IRQ_POL, 0);
-- 
1.7.10.4

