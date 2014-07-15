Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbaGOROV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:21 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63529 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaGORCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:14 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Enric Balletbo i Serra <eballetbo@iseebcn.com>,
        Tony Lindgren <tony@atomide.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 48/94] ARM: dts: Fix TI CPSW Phy mode selection on IGEP COM AQUILA.
Date: Tue, 15 Jul 2014 20:01:03 +0300
Message-Id: <1405443709-15288-48-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Enric Balletbo i Serra <eballetbo@iseebcn.com>

As this board use external clock for RMII interface we should specify 'rmii'
phy mode and 'rmii-clock-ext' to make ethernet working.

Signed-off-by: Enric Balletbo i Serra <eballetbo@iseebcn.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/am335x-igep0033.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-igep0033.dtsi b/arch/arm/boot/dts/am335x-igep0033.dtsi
index 8a0a72d..a1a0cc5 100644
--- a/arch/arm/boot/dts/am335x-igep0033.dtsi
+++ b/arch/arm/boot/dts/am335x-igep0033.dtsi
@@ -105,10 +105,16 @@
 
 &cpsw_emac0 {
 	phy_id = <&davinci_mdio>, <0>;
+	phy-mode = "rmii";
 };
 
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
+	phy-mode = "rmii";
+};
+
+&phy_sel {
+	rmii-clock-ext;
 };
 
 &elm {
-- 
1.7.10.4

