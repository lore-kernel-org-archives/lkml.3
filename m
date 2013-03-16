Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3CPGSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 02:18:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38662 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3CPGRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 02:17:02 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <santosh.shilimkar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lokeshvutla@ti.com>, Ambresh K <ambresh@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/8] memory: emif: setup LP settings on freq update
Date: Sat, 16 Mar 2013 11:46:42 +0530
Message-ID: <1363414608-7448-3-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
References: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

Program the power management shadow register on freq update
Else the concept of threshold frequencies dont really matter
as the system always uses the performance mode timing for LP
which is programmed in at init time.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Ambresh K <ambresh@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
Changes since V1: No changes

 drivers/memory/emif.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 508763c..5f3b7ed 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -819,6 +819,8 @@ static void setup_registers(struct emif_data *emif, struct emif_regs *regs)
 
 	writel(regs->sdram_tim2_shdw, base + EMIF_SDRAM_TIMING_2_SHDW);
 	writel(regs->phy_ctrl_1_shdw, base + EMIF_DDR_PHY_CTRL_1_SHDW);
+	writel(regs->pwr_mgmt_ctrl_shdw,
+	       base + EMIF_POWER_MANAGEMENT_CTRL_SHDW);
 
 	/* Settings specific for EMIF4D5 */
 	if (emif->plat_data->ip_rev != EMIF_4D5)
-- 
1.7.9.5

