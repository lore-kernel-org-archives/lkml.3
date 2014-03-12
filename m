Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaCLTE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:04:27 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:49001 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaCLTEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:04:24 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 9/9] ARM: zynq: DT: Migrate UART to Cadence binding
Date: Wed, 12 Mar 2014 12:03:03 -0700
Message-Id: <1394650983-24780-10-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zynq UART is Cadence IP and the driver has been renamed accordingly.
Migrate the DT to use the new binding for the UART driver.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Acked-by: Rob Herring <robh@kernel.org>
---
This change depends on 'tty: xuartps: Rebrand driver as Cadence UART',
which introduces the new clock-names.
---
 arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b67b19392ec..0ed0d4b0579a 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -67,19 +67,19 @@
 		};
 
 		uart0: uart@e0000000 {
-			compatible = "xlnx,xuartps";
+			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
 			status = "disabled";
 			clocks = <&clkc 23>, <&clkc 40>;
-			clock-names = "ref_clk", "aper_clk";
+			clock-names = "uart_clk", "pclk";
 			reg = <0xE0000000 0x1000>;
 			interrupts = <0 27 4>;
 		};
 
 		uart1: uart@e0001000 {
-			compatible = "xlnx,xuartps";
+			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
 			status = "disabled";
 			clocks = <&clkc 24>, <&clkc 41>;
-			clock-names = "ref_clk", "aper_clk";
+			clock-names = "uart_clk", "pclk";
 			reg = <0xE0001000 0x1000>;
 			interrupts = <0 50 4>;
 		};
-- 
1.9.0.1.g4196000

