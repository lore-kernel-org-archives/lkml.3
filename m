Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbaJ3JSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:18:10 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:60853 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758159AbaJ3JSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:18:06 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: db8500-prcmu: check return of devm_ioremap for error
Date: Thu, 30 Oct 2014 14:51:35 +0530
Message-Id: <1414660895-29255-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error check around return value of devm_ioremap is missing. Add the same
to avoid NULL pointer dereference.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mfd/db8500-prcmu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 193cf16..89ae8bf 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3167,6 +3167,11 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
 	}
 	tcdm_base = devm_ioremap(&pdev->dev, res->start,
 			resource_size(res));
+	if (!tcdm_base) {
+		dev_err(&pdev->dev,
+			"failed to ioremap prcmu-tcdm register memory\n");
+		return -ENOENT;
+	}
 
 	/* Clean up the mailbox interrupts after pre-kernel code. */
 	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
-- 
1.7.9.5

