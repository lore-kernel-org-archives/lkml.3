Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaLSSVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:21:17 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57347 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaLSSVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:21:16 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/3] microblaze: intc: Don't override error codes
Date: Fri, 19 Dec 2014 10:21:04 -0800
Message-Id: <1419013266-20568-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.0.1.g9ee0458
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just pass on error codes instead of overriding them.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/microblaze/kernel/intc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index 15c7c12ea0e7..01ae73088578 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -148,13 +148,13 @@ static int __init xilinx_intc_of_init(struct device_node *intc,
 	ret = of_property_read_u32(intc, "xlnx,num-intr-inputs", &nr_irq);
 	if (ret < 0) {
 		pr_err("%s: unable to read xlnx,num-intr-inputs\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	ret = of_property_read_u32(intc, "xlnx,kind-of-intr", &intr_mask);
 	if (ret < 0) {
 		pr_err("%s: unable to read xlnx,kind-of-intr\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (intr_mask > (u32)((1ULL << nr_irq) - 1))
-- 
2.2.0.1.g9ee0458

