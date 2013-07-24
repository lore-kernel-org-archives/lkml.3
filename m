Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab3GXI0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:26:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44843 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3GXI0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:26:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regmap: irq: make flags bool and put them in a bitfield
Date: Wed, 24 Jul 2013 10:26:42 +0200
Message-Id: <1374654402-4647-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes mask/wake_invert bool and puts all flags into a bitfield
for consistency and to save some space.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/linux/regmap.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 34ebe77..99b211a 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -486,10 +486,10 @@ struct regmap_irq_chip {
 	unsigned int ack_base;
 	unsigned int wake_base;
 	unsigned int irq_reg_stride;
-	bool init_ack_masked;
-	unsigned int mask_invert;
-	unsigned int wake_invert;
-	bool runtime_pm;
+	bool init_ack_masked:1;
+	bool mask_invert:1;
+	bool wake_invert:1;
+	bool runtime_pm:1;
 
 	int num_regs;
 
-- 
1.8.3.2

