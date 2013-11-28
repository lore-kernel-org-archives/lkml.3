Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3K1H1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:27:22 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40389 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K1H1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:27:19 -0500
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: grant-likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com
Subject: [PATCH v1 1/2] of: irq: Ignore disabled intc's when searching map
Date: Wed, 27 Nov 2013 23:26:12 -0800
Message-Id: <ee3c0c716da8f1b1146d8829bc5184fbf1c3ead2.1385623064.git.peter.crosthwaite@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
References: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
In-Reply-To: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
References: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When searching the interrupt map, if a matched parent is disabled, just
ignore it and move on with the search.

This allows for specifying connection of a single device IRQ to
multiple interrupt controllers via the interrupt map schema. This change
allows for selection of the active interrupt controller via the already
existing status = "disabled" mechanism.

Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/of/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 786b0b4..22e414b 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -217,6 +217,9 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 				goto fail;
 			}
 
+			if (!of_device_is_available(newpar))
+				match = 0;
+
 			/* Get #interrupt-cells and #address-cells of new
 			 * parent
 			 */
-- 
1.8.4.4

