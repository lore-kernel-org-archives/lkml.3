Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaDNQpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:45:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50347 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485AbaDNQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:54 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/15] bus: omap_l3_noc: remove iclk from omap_l3 struct
Date: Mon, 14 Apr 2014 11:25:21 -0500
Message-ID: <1397492726-17203-12-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we do not use iclk directly anymore. And, even if we had to, we
should be using pm_runtime APIs to do the same to be completely SoC
independent.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/bus/omap_l3_noc.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index a1931e8..573e40f 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -142,7 +142,6 @@ static struct l3_target_data *l3_targ[L3_MODULES] = {
 
 struct omap_l3 {
 	struct device *dev;
-	struct clk *ick;
 
 	/* memory base */
 	void __iomem *l3_base[L3_MODULES];
-- 
1.7.9.5

