Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab3DAWUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:20:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6683 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab3DAWUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:20:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 01 Apr 2013 15:19:34 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [REPOST V4 2/2] mfd: tps65090: Add resources for charger
Date: Mon, 1 Apr 2013 18:20:24 -0400
Message-ID: <1364854824-7647-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364854824-7647-1-git-send-email-rklein@nvidia.com>
References: <1364854824-7647-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add irq resources to pass to the charger mfd sub dev so
the charger can listen for interrupts.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v4:
 - Added of_compatible string to resources for tps65090-charger
v3:
 - no changes since v2
v2:
 - no changes since v1

 drivers/mfd/tps65090.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 98edb5be..fbd6ee6 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -56,12 +56,23 @@
 #define TPS65090_INT2_MASK_OVERLOAD_FET6		6
 #define TPS65090_INT2_MASK_OVERLOAD_FET7		7
 
+static struct resource charger_resources[] = {
+	{
+		.start  = TPS65090_IRQ_VAC_STATUS_CHANGE,
+		.end    = TPS65090_IRQ_VAC_STATUS_CHANGE,
+		.flags  = IORESOURCE_IRQ,
+	}
+};
+
 static struct mfd_cell tps65090s[] = {
 	{
 		.name = "tps65090-pmic",
 	},
 	{
 		.name = "tps65090-charger",
+		.num_resources = ARRAY_SIZE(charger_resources),
+		.resources = &charger_resources[0],
+		.of_compatible = "ti,tps65090-charger",
 	},
 };
 
-- 
1.7.9.5

