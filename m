Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423051AbaDKQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:28:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759632AbaDKQJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mischa Jonker <mjonker@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: [PATCH 3.13 61/65] ARC: [nsimosci] Change .dts to use generic 8250 UART
Date: Fri, 11 Apr 2014 09:11:33 -0700
Message-Id: <20140411161006.029155279@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mischa Jonker <mjonker@synopsys.com>

commit 6eda477b3c54b8236868c8784e5e042ff14244f0 upstream.

The Synopsys APB DW UART has a couple of special features that are not
in the System C model. In 3.8, the 8250_dw driver didn't really use these
features, but from 3.9 onwards, the 8250_dw driver has become incompatible
with our model.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/boot/dts/nsimosci.dts |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/arc/boot/dts/nsimosci.dts
+++ b/arch/arc/boot/dts/nsimosci.dts
@@ -11,7 +11,7 @@
 
 / {
 	compatible = "snps,nsimosci";
-	clock-frequency = <80000000>;	/* 80 MHZ */
+	clock-frequency = <20000000>;	/* 20 MHZ */
 	#address-cells = <1>;
 	#size-cells = <1>;
 	interrupt-parent = <&intc>;
@@ -44,15 +44,14 @@
 		};
 
 		uart0: serial@c0000000 {
-			compatible = "snps,dw-apb-uart";
+			compatible = "ns8250";
 			reg = <0xc0000000 0x2000>;
 			interrupts = <11>;
-			#clock-frequency = <80000000>;
 			clock-frequency = <3686400>;
 			baud = <115200>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			status = "okay";
+			no-loopback-test = <1>;
 		};
 
 		pgu0: pgu@c9000000 {


