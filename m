Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbbAYTQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:16:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbbAYSJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.14 27/98] ARC: [nsimosci] move peripherals to match model to FPGA
Date: Sun, 25 Jan 2015 10:06:45 -0800
Message-Id: <20150125180714.051980747@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit e8ef060b37c2d3cc5fd0c0edbe4e42ec1cb9768b upstream.

This allows the sdplite/Zebu images to run on OSCI simulation platform

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/boot/dts/nsimosci.dts |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/arc/boot/dts/nsimosci.dts
+++ b/arch/arc/boot/dts/nsimosci.dts
@@ -20,7 +20,7 @@
 		/* this is for console on PGU */
 		/* bootargs = "console=tty0 consoleblank=0"; */
 		/* this is for console on serial */
-		bootargs = "earlycon=uart8250,mmio32,0xc0000000,115200n8 console=tty0 console=ttyS0,115200n8 consoleblank=0 debug";
+		bootargs = "earlycon=uart8250,mmio32,0xf0000000,115200n8 console=tty0 console=ttyS0,115200n8 consoleblank=0 debug";
 	};
 
 	aliases {
@@ -46,9 +46,9 @@
 			#interrupt-cells = <1>;
 		};
 
-		uart0: serial@c0000000 {
+		uart0: serial@f0000000 {
 			compatible = "ns8250";
-			reg = <0xc0000000 0x2000>;
+			reg = <0xf0000000 0x2000>;
 			interrupts = <11>;
 			clock-frequency = <3686400>;
 			baud = <115200>;
@@ -57,21 +57,21 @@
 			no-loopback-test = <1>;
 		};
 
-		pgu0: pgu@c9000000 {
+		pgu0: pgu@f9000000 {
 			compatible = "snps,arcpgufb";
-			reg = <0xc9000000 0x400>;
+			reg = <0xf9000000 0x400>;
 		};
 
-		ps2: ps2@c9001000 {
+		ps2: ps2@f9001000 {
 			compatible = "snps,arc_ps2";
-			reg = <0xc9000400 0x14>;
+			reg = <0xf9000400 0x14>;
 			interrupts = <13>;
 			interrupt-names = "arc_ps2_irq";
 		};
 
-		eth0: ethernet@c0003000 {
+		eth0: ethernet@f0003000 {
 			compatible = "snps,oscilan";
-			reg = <0xc0003000 0x44>;
+			reg = <0xf0003000 0x44>;
 			interrupts = <7>, <8>;
 			interrupt-names = "rx", "tx";
 		};


