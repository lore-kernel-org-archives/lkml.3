Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaLSSVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:21:22 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42330 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaLSSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:21:19 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/3] microblaze: intc: Refactor DT sanity check
Date: Fri, 19 Dec 2014 10:21:05 -0800
Message-Id: <1419013266-20568-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.0.1.g9ee0458
In-Reply-To: <1419013266-20568-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1419013266-20568-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid funky casts and arithmetic.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/microblaze/kernel/intc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 01ae73088578..8965fd379570 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -157,7 +157,7 @@ static int __init xilinx_intc_of_init(struct device_node *intc,
 		return ret;
 	}
 
-	if (intr_mask > (u32)((1ULL << nr_irq) - 1))
+	if (intr_mask >> nr_irq)
 		pr_info(" ERROR: Mismatch in kind-of-intr param\n");
 
 	pr_info("%s: num_irq=%d, edge=0x%x\n",
-- 
2.2.0.1.g9ee0458

