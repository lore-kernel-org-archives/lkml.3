Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaIBLv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:51:26 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58290 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaIBLvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:51:23 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: et131x: et131x.c: sparse warning of incompatible types
Date: Tue,  2 Sep 2014 17:21:12 +0530
Message-Id: <1409658672-4196-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning:   incompatible types in comparison expression
			(different address spaces)

wolw and reg both are being used only for the initialization of 
the __iomem area.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/et131x/et131x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 52abe33..1037d93 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1135,7 +1135,7 @@ static void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 	u32 sa_lo;
 	u32 sa_hi = 0;
 	u32 pf_ctrl = 0;
-	u32 *wolw;
+	u32 __iomem *wolw;
 
 	/* Disable the MAC while it is being configured (also disable WOL) */
 	writel(0x8, &rxmac->ctrl);
@@ -1255,7 +1255,7 @@ static void et1310_config_txmac_regs(struct et131x_adapter *adapter)
 static void et1310_config_macstat_regs(struct et131x_adapter *adapter)
 {
 	struct macstat_regs __iomem *macstat = &adapter->regs->macstat;
-	u32 *reg;
+	u32 __iomem *reg;
 
 	/* initialize all the macstat registers to zero on the device  */
 	for (reg = &macstat->txrx_0_64_byte_frames;
-- 
1.8.1.2

