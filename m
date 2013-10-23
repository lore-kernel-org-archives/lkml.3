Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3JWJcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:32:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54400 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3JWJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:32:12 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ARM: dts: omap5-uevm: Correct twl6040 reset GPIO pinmux
Date: Wed, 23 Oct 2013 12:32:19 +0300
Message-ID: <1382520740-11197-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382520740-11197-1-git-send-email-peter.ujfalusi@ti.com>
References: <1382520740-11197-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the omap5-evm.dts file has been renamed to omap5-uevm.dts and the sEVM
support got deprecated in favor of uEVM (or Panda5) the content was not
validated.
On uEVM the twl6040 reset GPIO is from gpio5_141 and not via gpio5_145, which
was the case in sEVM.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index e06a04a..8432409 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -71,7 +71,7 @@
 
 	twl6040_pins: pinmux_twl6040_pins {
 		pinctrl-single,pins = <
-			0x18a (PIN_OUTPUT | MUX_MODE6)	/* perslimbus2_clock.gpio5_145 */
+			0x17e (PIN_OUTPUT | MUX_MODE6)	/* mcspi1_somi.gpio5_141 */
 		>;
 	};
 
-- 
1.8.4

