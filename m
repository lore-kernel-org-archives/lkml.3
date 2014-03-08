Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCHJaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:30:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43007 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaCHJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:30:11 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/28] phy: ti-pipe3: Fix suspend/resume and module reload
Date: Sat, 8 Mar 2014 14:59:26 +0530
Message-ID: <1394270969-11851-26-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

Due to Errata i783, SATA breaks if its DPLL is idled. The recommeded
workaround to issue a softreset to the SATA controller doesn't seem to
work. Here we just prevent SATA DPLL from Idling and hence avoid
the issue altogether.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-ti-pipe3.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index 12cc900..5913676 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -238,6 +238,10 @@ static int ti_pipe3_exit(struct phy *x)
 	u32 val;
 	unsigned long timeout;
 
+	/* SATA DPLL can't be powered down due to Errata i783 */
+	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-sata"))
+		return 0;
+
 	/* Put DPLL in IDLE mode */
 	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
 	val |= PLL_IDLE;
-- 
1.7.9.5

