Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3CAMHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:07:47 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:59737 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab3CAMHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:07:46 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] mfd: stmpe: DT: Enable no-irq mode configuration
Date: Fri, 1 Mar 2013 13:07:16 +0100
Message-ID: <1362139636-23579-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

If there is no interrupt property into stmpe node
then activate the no-irq mode by setting the irq
value to -1.

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stmpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 4b11202..e550dcb 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1057,6 +1057,9 @@ int stmpe_probe(struct stmpe_client_info *ci, int partnum)
 			return -ENOMEM;
 
 		stmpe_of_probe(pdata, np);
+
+		if (of_find_property(np, "interrupts", NULL) == NULL)
+			ci->irq = -1;
 	}
 
 	stmpe = devm_kzalloc(ci->dev, sizeof(struct stmpe), GFP_KERNEL);
-- 
1.7.11.3

