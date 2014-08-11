Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaHKNjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:39:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:5467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbaHKNjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:39:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="586455706"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: Linus <linus.walleij@linaro.org>
Cc: <mika.westerberg@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] pinctrl: baytrail: resolve unbalanced IRQ wake disable warning
Date: Mon, 11 Aug 2014 16:51:55 +0300
Message-Id: <1407765115-31662-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the IRQCHIP_SKIP_SET_WAKE flag to baytrail gpio irq_chip
to resolve unbalaced IRQ wake disable warnings.

Suggested-by: Borun Fu <borun.fu@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 975572e..f8359aa 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -481,6 +481,7 @@ static struct irq_chip byt_irqchip = {
 	.irq_set_type = byt_irq_type,
 	.irq_request_resources = byt_irq_reqres,
 	.irq_release_resources = byt_irq_relres,
+	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
 static void byt_gpio_irq_init_hw(struct byt_gpio *vg)
-- 
1.8.3.2

