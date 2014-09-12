Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaILDSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:18:54 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:54642 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaILDSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:18:51 -0400
From: Sean Cross <xobs@kosagi.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Cc: bunnie@kosagi.com, Sean Cross <xobs@kosagi.com>
Subject: [PATCH v2 1/2] mfd: stmpe: support gpio over irq under device tree
Date: Fri, 12 Sep 2014 11:18:33 +0800
Message-Id: <1410491914-23378-2-git-send-email-xobs@kosagi.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410491914-23378-1-git-send-email-xobs@kosagi.com>
References: <1410491914-23378-1-git-send-email-xobs@kosagi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stmpe_platform_data has a irq_over_gpio field, which allows the
system to read STMPE events whenever an IRQ occurs on a GPIO pin.
This patch adds the ability to configure this field and to use a GPIO
as an IRQ source for boards configuring the STMPE in device tree.

Signed-off-by: Sean Cross <xobs@kosagi.com>
---
 drivers/mfd/stmpe.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 3b6bfa7..4c42b05 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1122,7 +1122,12 @@ static void stmpe_of_probe(struct stmpe_platform_data *pdata,
 	if (pdata->id < 0)
 		pdata->id = -1;
 
-	pdata->irq_trigger = IRQF_TRIGGER_NONE;
+	pdata->irq_gpio = of_get_named_gpio_flags(np, "irq-gpio", 0,
+				&pdata->irq_trigger);
+	if (gpio_is_valid(pdata->irq_gpio))
+		pdata->irq_over_gpio = 1;
+	else
+		pdata->irq_trigger = IRQF_TRIGGER_NONE;
 
 	of_property_read_u32(np, "st,autosleep-timeout",
 			&pdata->autosleep_timeout);
-- 
2.1.0

