Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaAPK5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:57:43 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:60241 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbaAPK5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:57:39 -0500
From: <srinivas.kandagatla@st.com>
To: <netdev@vger.kernel.org>
Cc: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@st.com>
Subject: [PATCH v2 2/9] net: stmmac: mdio: remove reset gpio free
Date: Thu, 16 Jan 2014 10:51:58 +0000
Message-ID: <1389869518-28095-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389869450-28003-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389869450-28003-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes gpio_free for reset line of the phy, driver stores
the gpio number in its private data-structure to use in future. As the
driver uses this pin in future this pin should not be freed.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index fe7bc99..aab12d2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -166,7 +166,6 @@ static int stmmac_mdio_reset(struct mii_bus *bus)
 			udelay(data->delays[1]);
 			gpio_set_value(reset_gpio, active_low ? 1 : 0);
 			udelay(data->delays[2]);
-			gpio_free(reset_gpio);
 		}
 	}
 #endif
-- 
1.7.6.5

