Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaIQM3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:29:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:51939 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbaIQM3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,540,1406617200"; 
   d="scan'208";a="478113981"
From: Loic Poulain <loic.poulain@intel.com>
To: mathias.nyman@linux.intel.com, heikki.krogerus@linux.intel.com,
        mika.westerberg@intel.com, samuel.ortiz@intel.com
Cc: linux-kernel@vger.kernel.org, Loic Poulain <loic.poulain@intel.com>
Subject: [PATCH] pinctrl: baytrail: Clear DIRECT_IRQ bit
Date: Wed, 17 Sep 2014 14:30:35 +0200
Message-Id: <1410957035-13965-1-git-send-email-loic.poulain@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct Irq En bit can be initialized to a bad value.
This bit has to be cleared for io access mode.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 975572e..94902f7 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -44,6 +44,7 @@
 
 /* BYT_CONF0_REG register bits */
 #define BYT_IODEN		BIT(31)
+#define BYT_DIRECT_IRQ		BIT(27)
 #define BYT_TRIG_NEG		BIT(26)
 #define BYT_TRIG_POS		BIT(25)
 #define BYT_TRIG_LVL		BIT(24)
@@ -232,7 +233,7 @@ static int byt_irq_type(struct irq_data *d, unsigned type)
 	/* For level trigges the BYT_TRIG_POS and BYT_TRIG_NEG bits
 	 * are used to indicate high and low level triggering
 	 */
-	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
+	value &= ~(BYT_DIRECT_IRQ | BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
 
 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
-- 
1.8.3.2

