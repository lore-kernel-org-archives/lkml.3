Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaBTOoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:44:38 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:47284 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaBTOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:25 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 06/10] spi: sh-msiof: Improve binding documentation
Date: Thu, 20 Feb 2014 15:43:05 +0100
Message-Id: <1392907389-21798-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

  - Add missing "interrupt-parent", "#address-cells", "#size-cells", and
    "clocks" properties,
  - Add missing default values for "renesas,tx-fifo-size" and
    "renesas,rx-fifo-size",
  - Add a reference to the pinctrl documentation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/spi/sh-msiof.txt |   24 ++++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/sh-msiof.txt b/Documentation/devicetree/bindings/spi/sh-msiof.txt
index e6222106ca36..52cf5c78705b 100644
--- a/Documentation/devicetree/bindings/spi/sh-msiof.txt
+++ b/Documentation/devicetree/bindings/spi/sh-msiof.txt
@@ -1,12 +1,22 @@
 Renesas MSIOF spi controller
 
 Required properties:
-- compatible : 	"renesas,sh-msiof" for SuperH or
-		"renesas,sh-mobile-msiof" for SH Mobile series
-- reg : Offset and length of the register set for the device
-- interrupts : interrupt line used by MSIOF
+- compatible           : "renesas,sh-msiof" for SuperH, or
+			 "renesas,sh-mobile-msiof" for SH Mobile series.
+- reg                  : Offset and length of the register set for the device
+- interrupt-parent     : The phandle for the interrupt controller that
+			 services interrupts for this device
+- interrupts           : Interrupt specifier
+- #address-cells       : Must be <1>
+- #size-cells          : Must be <0>
 
 Optional properties:
-- num-cs		: total number of chip-selects
-- renesas,tx-fifo-size	: Overrides the default tx fifo size given in words
-- renesas,rx-fifo-size	: Overrides the default rx fifo size given in words
+- clocks               : Must contain a reference to the functional clock.
+- num-cs               : Total number of chip-selects
+- renesas,tx-fifo-size : Overrides the default tx fifo size given in words
+			 (default is 64)
+- renesas,rx-fifo-size : Overrides the default rx fifo size given in words
+			 (default is 64)
+
+Pinctrl properties might be needed, too.  See
+Documentation/devicetree/bindings/pinctrl/renesas,*.
-- 
1.7.9.5

