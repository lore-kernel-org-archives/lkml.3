Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbaD1PPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:15:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49242 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbaD1PP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:15:28 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>
Subject: [PATCH V3 03/20] bus: omap_l3_noc: remove iclk from omap_l3 struct
Date: Mon, 28 Apr 2014 10:14:43 -0500
Message-ID: <1398698101-25513-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we do not use iclk directly anymore. And, even if we had to, we
should be using pm_runtime APIs to do the same to be completely SoC
independent.

Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Darren Etheridge <detheridge@ti.com>
---
change in V3: none
 drivers/bus/omap_l3_noc.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index b3c81f2..31984cf 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -159,7 +159,6 @@ static u32 *l3_targ[L3_MODULES] = {
 
 struct omap_l3 {
 	struct device *dev;
-	struct clk *ick;
 
 	/* memory base */
 	void __iomem *l3_base[L3_MODULES];
-- 
1.7.9.5

