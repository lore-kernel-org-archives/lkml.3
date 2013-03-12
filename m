Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3CLWKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:10:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7791 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab3CLWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:10:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 15:10:02 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [Patch v3 2/4] mfd: tps65090: Add resources for charger
Date: Tue, 12 Mar 2013 18:08:07 -0400
Message-ID: <1363126089-9071-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
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
v3:
 - no changes since v2
v2:
 - no changes since v1

 drivers/mfd/tps65090.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 98edb5be..88846ae 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -56,12 +56,22 @@
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
 	},
 };
 
-- 
1.7.9.5

