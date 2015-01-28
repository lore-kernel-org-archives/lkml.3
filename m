Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbbA1BiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:38:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053AbbA1BiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Carlos Soto <csotoalonso@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.14 18/77] ARM: dts: imx25: Fix PWM "per" clocks
Date: Tue, 27 Jan 2015 17:26:56 -0800
Message-Id: <20150128012746.508262189@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7ecd0bde5bfea524a843ad8fa8cb66ccbce68779 upstream.

Currently PWM functionality is broken on mx25 due to the wrong assignment of the
PWM "per" clock.

According to Documentation/devicetree/bindings/clock/imx25-clock.txt:
	pwm_ipg_per		52

,so update the pwm "per" to use 'pwm_ipg_per' instead of 'per10' clock.

With this change PWM can work fine on mx25.

Reported-by: Carlos Soto <csotoalonso@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx25.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -352,7 +352,7 @@
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				#pwm-cells = <2>;
 				reg = <0x53fa0000 0x4000>;
-				clocks = <&clks 106>, <&clks 36>;
+				clocks = <&clks 106>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <36>;
 			};
@@ -371,7 +371,7 @@
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				#pwm-cells = <2>;
 				reg = <0x53fa8000 0x4000>;
-				clocks = <&clks 107>, <&clks 36>;
+				clocks = <&clks 107>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <41>;
 			};
@@ -412,7 +412,7 @@
 			pwm4: pwm@53fc8000 {
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				reg = <0x53fc8000 0x4000>;
-				clocks = <&clks 108>, <&clks 36>;
+				clocks = <&clks 108>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <42>;
 			};
@@ -458,7 +458,7 @@
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				#pwm-cells = <2>;
 				reg = <0x53fe0000 0x4000>;
-				clocks = <&clks 105>, <&clks 36>;
+				clocks = <&clks 105>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <26>;
 			};


