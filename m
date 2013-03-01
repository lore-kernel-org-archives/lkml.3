Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3CAMHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:07:49 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:49263 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132Ab3CAMHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:07:48 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] mfd: stmpe: DT: Add stmpe-i2c dt alias to get id device
Date: Fri, 1 Mar 2013 13:07:26 +0100
Message-ID: <1362139646-23613-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

This patch augments the STMP driver to read the device id
from the stmpe-i2c dt alias if present.

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stmpe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index e550dcb..bc85877 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1015,7 +1015,10 @@ void stmpe_of_probe(struct stmpe_platform_data *pdata, struct device_node *np)
 {
 	struct device_node *child;
 
-	pdata->id = -1;
+	pdata->id = of_alias_get_id(np, "stmpe-i2c");
+	if (pdata->id < 0)
+		pdata->id = -1;
+
 	pdata->irq_trigger = IRQF_TRIGGER_NONE;
 
 	of_property_read_u32(np, "st,autosleep-timeout",
-- 
1.7.11.3

