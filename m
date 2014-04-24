Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaDXJi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:38:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46892 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaDXIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mischa Jonker <mjonker@synopsys.com>, Vineet Gupta <vgupta@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 131/182] ARC: [nsimosci] Change .dts to use generic 8250 UART
Date: Thu, 24 Apr 2014 09:50:56 +0100
Message-Id: <1398329507-5911-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arc/boot/dts/nsimosci.dts | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arc/boot/dts/nsimosci.dts b/arch/arc/boot/dts/nsimosci.dts
index ea16d78..8bd238c 100644
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
1.9.1

