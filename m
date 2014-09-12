Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaILOHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:07:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52632 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbaILOGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:06:19 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] phy: miphy365x: Fix off-by-one error
Date: Fri, 12 Sep 2014 19:36:12 +0530
Message-ID: <1410530774-6715-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530774-6715-1-git-send-email-kishon@ti.com>
References: <1410530774-6715-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

We index the RX/TX speed select values in the following way:

  rx_tx_spd[miphy_phy->sata_gen];

However rx_tx_spd[] starts at index zero and the SATA_GENx's start
at one.  In this patch we pad out the first element in rx_tx_spd[]
in an attempt to realign the values.

Cc: Alexandre Torgue <alexandre.torgue@st.com>
Reported-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-miphy365x.c |    1 +
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
1.7.9.5

