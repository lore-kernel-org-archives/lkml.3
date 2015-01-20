Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbbATHJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:09:49 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:62394 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbATHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:09:46 -0500
From: Romain Perier <romain.perier@gmail.com>
To: peppe.cavallaro@st.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, heiko@sntech.de,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: [PATCH v2 1/4] net: stmmac: dwmac-rk: Don't set the regulator voltage for phy from the driver
Date: Tue, 20 Jan 2015 07:09:37 +0000
Message-Id: <1421737780-1533-2-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
References: <1421737780-1533-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As these settings can be directly expressed from devicetree for both fixed
regulators and pmic-integrated regulators, it is more standard to set them
from dts and let the regulator framework use the right voltage informations
when it is used in the driver.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index 35f9b86..06e1637 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -303,7 +303,6 @@ static int phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
 	} else {
 		if (enable) {
 			if (!regulator_is_enabled(ldo)) {
-				regulator_set_voltage(ldo, 3300000, 3300000);
 				ret = regulator_enable(ldo);
 				if (ret != 0)
 					dev_err(dev, "%s: fail to enable %s\n",
-- 
1.9.1

