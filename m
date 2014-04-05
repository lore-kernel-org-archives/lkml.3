Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaDENJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 09:09:48 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:33912 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaDENJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 09:09:47 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: <arc-linux-dev@synopsys.com>, <stable@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Mischa Jonker <mjonker@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH Resend 1/2] ARC: [nsimosci] Change .dts to use generic 8250 UART
Date: Sat, 5 Apr 2014 18:39:10 +0530
Message-ID: <1396703351-8423-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396703351-8423-1-git-send-email-vgupta@synopsys.com>
References: <1396703351-8423-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mischa Jonker <mjonker@synopsys.com>

The Synopsys APB DW UART has a couple of special features that are not
in the System C model. In 3.8, the 8250_dw driver didn't really use these
features, but from 3.9 onwards, the 8250_dw driver has become incompatible
with our model.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: <stable@vger.kernel.org>   #3.10, 3.12, 3.13, 3.14
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
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
1.8.3.2

