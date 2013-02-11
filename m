Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3BKPoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:44:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58298 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab3BKPom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:44:42 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <rogerq@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 2/2] ARM: dts: omap4-panda: Add clock alias for USB PHY
Date: Mon, 11 Feb 2013 17:44:24 +0200
Message-ID: <1360597464-8491-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360597464-8491-1-git-send-email-rogerq@ti.com>
References: <1360597464-8491-1-git-send-email-rogerq@ti.com>
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
index d6e59c7..a7d66cc 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -86,6 +86,13 @@
 		reset-supply = <&hsusb1_reset>;
 		vcc-supply = <&hsusb1_power>;
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

