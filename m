Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab3FSF6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:58:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59515 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab3FSF6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:58:44 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <gg@slimlogic.co.uk>
Subject: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
Date: Wed, 19 Jun 2013 11:27:47 +0530
Message-ID: <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

Check if irq value obtained is valid. If it is not valid
then skip the irq request step and go ahead with the probe.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 drivers/mfd/palmas.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 62fa728..b24bee3 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -290,6 +290,11 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
+	if (!palmas->irq) {
+		dev_warn(palmas->dev, "IRQ missing: skipping irq request\n");
+		goto no_irq;
+	}
+
 	/* Change interrupt line output polarity */
 	if (pdata->irq_flags & IRQ_TYPE_LEVEL_HIGH)
 		reg = PALMAS_POLARITY_CTRL_INT_POLARITY;
@@ -316,6 +321,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
+no_irq:
 	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
 	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
 			PALMAS_PRIMARY_SECONDARY_PAD1);
-- 
1.7.5.4

