Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab3CLLo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:44:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39629 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab3CLLod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:44:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 24/24] ARM: dts: omap4-panda: Add clock alias for USB PHY
Date: Tue, 12 Mar 2013 13:43:26 +0200
Message-ID: <1363088606-2692-25-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363088606-2692-1-git-send-email-rogerq@ti.com>
References: <1363088606-2692-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Panda, the USB Host PHY is clocked by FREF3_CLK (auxclk3_ck) pin
of the OMAP. Provide this information in the device tree.

CC: Russell King <linux@arm.linux.org.uk>
CC: Rajendra Nayak <rnayak@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4-panda.dts |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index cfc7683..0ba4458 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -87,6 +87,13 @@
 		vcc-supply = <&hsusb1_power>;
 		clock-frequency = <19200000>;
 	};
+
+	/* hsusb1_phy is clocked by FREF_CLK3 i.e. auxclk3 */
+	clock_alias {
+		clock-name = "auxclk3_ck";
+		clock-alias = "main_clk";
+		device = <&hsusb1_phy>;
+	};
 };
 
 &omap4_pmx_core {
-- 
1.7.4.1

