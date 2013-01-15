Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3AOWHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:07:02 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21473 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3AOWHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:07:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-b3-50f5d3028354
From: Byungho An <bh74.an@samsung.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, kgene.kim@samsung.com
Subject: [PATCH net-next 1/3] net: stmmac: add gmac autoneg set for SGMII, TBI,
 and  RTBI
Date: Tue, 15 Jan 2013 14:06:56 -0800
Message-id: <00d301cdf36c$a3acc9c0$eb065d40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac3zbJJ5tSynYaFfRpqfHUtFyZgYTg==
Content-language: en-zw
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ12my18DDM681LO4vGsOm8WxBWIO
	TB6fN8kFMEZx2aSk5mSWpRbp2yVwZZxv7GMu6JasuPZtFmMD40TRLkZODgkBE4kvG5ayQ9hi
	EhfurWfrYuTiEBJYxigx+ek2IIcDrGjn2kyI+CJGiTu/1jFBOL8ZJb58PckG0s0moCbRPPMy
	WIOIgIXEibYskDCzQI3E1cs3GEFsYYFoiQ99n1hAbBYBVYnlm6awgti8ApYSX//8YISwBSV+
	TL7HAtGrJbF+53EmCFteYvOat8wQhypI7Dj7GqxeREBPYu2th4wga5kFxCWmNRVBjBeQ+Db5
	EAvE+bISmw4wg1wsIdDPLjGp7TIrxBhJiYMrbrBMYBSbhWTzLCSbZyHZPAthwwJGllWMoqkF
	yQXFSem5RnrFibnFpXnpesn5uZsYIdEivYNxVYPFIUYBDkYlHl7Pwq8BQqyJZcWVuYcYJTiY
	lUR4484DhXhTEiurUovy44tKc1KLDzH6AB0+kVlKNDkfGMl5JfGGxsYmZiamJuaWpuamOISV
	xHkZTz0JEBJITyxJzU5NLUgtghnHxMEp1cBYu2/XDO9bVsz1BUc4QyuXPT4X+yPqw/pEsUQV
	u0h2eUfZgndnNKvF56wxKPnCL+Nqm50hcOTy43usrPbBOocD1j76mMWW9SPZtsaS/bdnTHF4
	l5uw5NzFloq5KozL4mcwb2ST9HN6qDQriXfu31/KdVMd5n+dP5V9SbVN4QqGyyeevwur8lZi
	Kc5INNRiLipOBAA74frXwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jAV2my18DDM6f1LC4vGsOm8WxBWIO
	TB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAE1WUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWacb+xjLuiWrLj2
	bRZjA+NE0S5GDg4JAROJnWszuxg5gUwxiQv31rN1MXJxCAksYpS482sdE4Tzm1Hiy9eTbCBV
	bAJqEs0zL7OBNIsIWEicaMsCCTML1EhcvXyDEcQWFoiW+ND3iQXEZhFQlVi+aQoriM0rYCnx
	9c8PRghbUOLH5HssEL1aEut3HmeCsOUlNq95ywxxkILEjrOvwepFBPQk1t56yAiylllAXGJa
	U9EERoFZSCbNQjJpFpJJsxA6FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjsVn0jsY
	VzVYHGIU4GBU4uH1LPwaIMSaWFZcmXuIUYKDWUmEN+48UIg3JbGyKrUoP76oNCe1+BCjD9Cf
	E5mlRJPzgWkiryTe0NjEzMjSyMzCyMTcHIewkjgv46knAUIC6YklqdmpqQWpRTDjmDg4pRoY
	KxJkHz1ZJXj01893pnEt5nHbXy7cmHcjY/byb+dmzvkn9GDPZk53n61P+tUc7866UfB3QUlM
	apfg1v/SK7vm8qR0xagudY9tym0o98rlaah69HqVyN/6nxHlvtdN+NjeZ/dX8qgbP119/YRY
	pOTegE7JXbb/Xl523LR8Xrmq+M35OtvFisWLlFiKMxINtZiLihMBhx6AavICAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds gmac autoneg set function for SGMII, TBI,
or RTBI interface. In case of PHY's autoneg is set, gmac's
autoneg enable bit should set. After checking phy's autoneg
if phydev's autoneg is '1' gmac's ANE bit set for those
interface.

Signed-off-by: Byungho An <bh74.an@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |   11 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    9 +++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h
b/drivers/net/ethernet/stmicro/stmmac/common.h
index 186d148..72ba769 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -344,6 +344,7 @@ struct stmmac_ops {
 	void (*reset_eee_mode) (void __iomem *ioaddr);
 	void (*set_eee_timer) (void __iomem *ioaddr, int ls, int tw);
 	void (*set_eee_pls) (void __iomem *ioaddr, int link);
+	void (*set_autoneg) (void __iomem *ioaddr);
 };
 
 struct mac_link {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index bfe0226..a0737b39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -297,6 +297,16 @@ static void  dwmac1000_set_eee_timer(void __iomem
*ioaddr, int ls, int tw)
 	writel(value, ioaddr + LPI_TIMER_CTRL);
 }
 
+static void dwmac1000_set_autoneg(void __iomem *ioaddr)
+{
+	u32 value;
+
+	value = readl(ioaddr + GMAC_AN_CTRL);
+	value |= 0x1000;
+	writel(value, ioaddr + GMAC_AN_CTRL);
+}
+
+
 static const struct stmmac_ops dwmac1000_ops = {
 	.core_init = dwmac1000_core_init,
 	.rx_ipc = dwmac1000_rx_ipc_enable,
@@ -311,6 +321,7 @@ static const struct stmmac_ops dwmac1000_ops = {
 	.reset_eee_mode =  dwmac1000_reset_eee_mode,
 	.set_eee_timer =  dwmac1000_set_eee_timer,
 	.set_eee_pls =  dwmac1000_set_eee_pls,
+	.set_autoneg =  dwmac1000_set_autoneg,
 };
 
 struct mac_device_info *dwmac1000_setup(void __iomem *ioaddr)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f07c061..3e28934 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1007,6 +1007,7 @@ static int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
+	int interface = priv->plat->interface;
 
 	clk_prepare_enable(priv->stmmac_clk);
 
@@ -1041,6 +1042,14 @@ static int stmmac_open(struct net_device *dev)
 	/* Initialize the MAC Core */
 	priv->hw->mac->core_init(priv->ioaddr);
 
+	/* If phy autoneg is on, set gmac autoneg for SGMII, TBI and RTBI*/
+	if (interface == PHY_INTERFACE_MODE_SGMII ||
+	    interface == PHY_INTERFACE_MODE_TBI ||
+	    interface == PHY_INTERFACE_MODE_RTBI) {
+		if (priv->phydev->autoneg)
+			priv->hw->mac->set_autoneg(priv->ioaddr);
+	}
+
 	/* Request the IRQ lines */
 	ret = request_irq(dev->irq, stmmac_interrupt,
 			 IRQF_SHARED, dev->name, dev);
-- 
1.7.10.4


