Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbaH1OAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:00:35 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:34366 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaH1OAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:00:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, kishon@ti.com,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH] phy: miphy365x: Fix off-by-one error
Date: Thu, 28 Aug 2014 14:59:50 +0100
Message-Id: <1409234390-20168-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We index the RX/TX speed select values in the following way:

  rx_tx_spd[miphy_phy->sata_gen];

However rx_tx_spd[] starts at index zero and the SATA_GENx's start
at one.  In this patch we pad out the first element in rx_tx_spd[]
in an attempt to realign the values.

Cc: Alexandre Torgue <alexandre.torgue@st.com>
Reported-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/phy/phy-miphy365x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
index e111baf..e0fb7a1 100644
--- a/drivers/phy/phy-miphy365x.c
+++ b/drivers/phy/phy-miphy365x.c
@@ -163,6 +163,7 @@ enum miphy_sata_gen {
 };
 
 static u8 rx_tx_spd[] = {
+	0, /* GEN0 doesn't exist. */
 	TX_SPDSEL_GEN1_VAL | RX_SPDSEL_GEN1_VAL,
 	TX_SPDSEL_GEN2_VAL | RX_SPDSEL_GEN2_VAL,
 	TX_SPDSEL_GEN3_VAL | RX_SPDSEL_GEN3_VAL
-- 
1.9.1

