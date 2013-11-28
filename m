Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3K1H1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:27:53 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48500 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3K1H1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:27:51 -0500
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: grant-likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com
Subject: [PATCH v1 2/2] of: irq: Ignore disabled interrupt controllers
Date: Wed, 27 Nov 2013 23:26:13 -0800
Message-Id: <e395866d7910723ed8cf82ba9475ef51ac6443f2.1385623064.git.peter.crosthwaite@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
References: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
In-Reply-To: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
References: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When searching the system for interrupt controllers, skip over any
that are explicitly disabled.

This makes interrupt controllers consistent with regular devices,
which can be marked as do-not-probe via the status = "disabled" dts
property.

Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/of/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 22e414b..bf80268 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -441,7 +441,8 @@ void __init of_irq_init(const struct of_device_id *matches)
 	INIT_LIST_HEAD(&intc_parent_list);
 
 	for_each_matching_node(np, matches) {
-		if (!of_find_property(np, "interrupt-controller", NULL))
+		if (!of_find_property(np, "interrupt-controller", NULL) ||
+				!of_device_is_available(np))
 			continue;
 		/*
 		 * Here, we allocate and populate an intc_desc with the node
-- 
1.8.4.4

