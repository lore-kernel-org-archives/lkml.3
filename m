Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaCDRR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:17:57 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52388 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaCDRRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:17:54 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 5/6] ARM: zynq: DT: Migrate UART to Cadence binding
Date: Tue,  4 Mar 2014 09:17:28 -0800
Message-Id: <1393953449-28551-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Zynq UART is Cadence IP and the driver has been renamed accordingly.
Migrate the DT to use the new binding for the UART driver.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b67b19392ec..a229a14834ce 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -67,19 +67,19 @@
 		};
 
 		uart0: uart@e0000000 {
-			compatible = "xlnx,xuartps";
+			compatible = "cdns,uart-r1p8";
 			status = "disabled";
 			clocks = <&clkc 23>, <&clkc 40>;
-			clock-names = "ref_clk", "aper_clk";
+			clock-names = "uart_clk", "pclk";
 			reg = <0xE0000000 0x1000>;
 			interrupts = <0 27 4>;
 		};
 
 		uart1: uart@e0001000 {
-			compatible = "xlnx,xuartps";
+			compatible = "cdns,uart-r1p8";
 			status = "disabled";
 			clocks = <&clkc 24>, <&clkc 41>;
-			clock-names = "ref_clk", "aper_clk";
+			clock-names = "uart_clk", "pclk";
 			reg = <0xE0001000 0x1000>;
 			interrupts = <0 50 4>;
 		};
-- 
1.9.0.1.g4196000

