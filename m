Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab3CSXFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:05:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27221 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab3CSXFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:05:51 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355126400"; 
   d="scan'208";a="31046043"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] irqchip: gic: fix irq_trigger return
Date: Tue, 19 Mar 2013 16:05:49 -0700
Message-Id: <1363734349-32635-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

The genirq layer expects a 0 in case of failure but the code is
returning -ENXIO. Fix it.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/irqchip/irq-gic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 644d724..2ebf28a 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -236,7 +236,8 @@ static int gic_retrigger(struct irq_data *d)
 	if (gic_arch_extn.irq_retrigger)
 		return gic_arch_extn.irq_retrigger(d);
 
-	return -ENXIO;
+	/* the genirq layer expects 0 for a failure */
+	return 0;
 }
 
 #ifdef CONFIG_SMP
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

