Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaDRJ0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:26:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46063 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbaDRJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mischa Jonker <mjonker@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 70/72] ARC: [nsimosci] Change .dts to use generic 8250 UART
Date: Fri, 18 Apr 2014 11:22:43 +0200
Message-Id: <83380df6eb2169afa029b82b9e7d6794e2e7a465.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mischa Jonker <mjonker@synopsys.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6eda477b3c54b8236868c8784e5e042ff14244f0 upstream.

The Synopsys APB DW UART has a couple of special features that are not
in the System C model. In 3.8, the 8250_dw driver didn't really use these
features, but from 3.9 onwards, the 8250_dw driver has become incompatible
with our model.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arc/boot/dts/nsimosci.dts | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arc/boot/dts/nsimosci.dts b/arch/arc/boot/dts/nsimosci.dts
index ea16d782af58..8bd238c34c7d 100644
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
-- 
1.9.2

