Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaLSSVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:21:32 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60716 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaLSSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:21:21 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 3/3] microblaze: intc: Reformat output
Date: Fri, 19 Dec 2014 10:21:06 -0800
Message-Id: <1419013266-20568-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.0.1.g9ee0458
In-Reply-To: <1419013266-20568-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1419013266-20568-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A message was using pr_info level output for a message including "ERROR"
which is not really a fatal error.
Remove the 'ERROR' from that message, use pr_warn loglevel and add the
function name to the output to give users a chance to find the culprit
in case the warning triggers.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/microblaze/kernel/intc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 8965fd379570..719feee1e043 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -158,7 +158,7 @@ static int __init xilinx_intc_of_init(struct device_node *intc,
 	}
 
 	if (intr_mask >> nr_irq)
-		pr_info(" ERROR: Mismatch in kind-of-intr param\n");
+		pr_warn("%s: mismatch in kind-of-intr param\n", __func__);
 
 	pr_info("%s: num_irq=%d, edge=0x%x\n",
 		intc->full_name, nr_irq, intr_mask);
-- 
2.2.0.1.g9ee0458

