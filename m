Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbbAMMXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:23:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34178 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbbAMMXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:23:37 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 3/4] ARM: dts: DRA7: Fix SATA PHY node
Date: Tue, 13 Jan 2015 14:23:21 +0200
Message-ID: <1421151802-7396-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421151802-7396-1-git-send-email-rogerq@ti.com>
References: <1421151802-7396-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sata_ref_clk is a reference clock to the SATA phy.
This fixes SATA malfunction across suspend/resume or when
SATA driver is used as a module.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 22771bc..8d2a635 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1090,8 +1090,8 @@
 				      <0x4A096800 0x40>; /* pll_ctrl */
 				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
 				ctrl-module = <&omap_control_sata>;
-				clocks = <&sys_clkin1>;
-				clock-names = "sysclk";
+				clocks = <&sys_clkin1>, <&sata_ref_clk>;
+				clock-names = "sysclk", "refclk";
 				#phy-cells = <0>;
 			};
 
-- 
2.1.0

