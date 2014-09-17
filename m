Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaIQN6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:58:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:22327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaIQN57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:57:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,540,1406617200"; 
   d="scan'208";a="478131206"
From: Loic Poulain <loic.poulain@intel.com>
To: linus.walleij@linaro.org, heikki.krogerus@linux.intel.com,
        mika.westerberg@intel.com, mathias.nyman@linux.intel.com,
        samuel.ortiz@intel.com
Cc: linux-kernel@vger.kernel.org, Loic Poulain <loic.poulain@intel.com>
Subject: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
Date: Wed, 17 Sep 2014 15:47:01 +0200
Message-Id: <1410961621-15231-1-git-send-email-loic.poulain@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct Irq En bit can be initialized to a bad value.
This bit has to be cleared for io access mode.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 v2: Apply over ff998356b644ebe723127bd9eec6040b59a4a4f6 + add Warning

 drivers/pinctrl/pinctrl-baytrail.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 701a646..77db3db 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -230,10 +230,13 @@ static int byt_irq_type(struct irq_data *d, unsigned type)
 	spin_lock_irqsave(&vg->lock, flags);
 	value = readl(reg);

+	WARN(value & BYT_DIRECT_IRQ_EN, "Clearing direct_irq_en bit");
+
 	/* For level trigges the BYT_TRIG_POS and BYT_TRIG_NEG bits
 	 * are used to indicate high and low level triggering
 	 */
-	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
+	value &= ~(BYT_DIRECT_IRQ_EN | BYT_TRIG_POS | BYT_TRIG_NEG |
+		   BYT_TRIG_LVL);

 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
--
1.8.3.2

