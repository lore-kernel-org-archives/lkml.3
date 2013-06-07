Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3FGIqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:46:36 -0400
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:46909 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239Ab3FGIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:45:31 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 04:45:30 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC 11/50] ARM: at91: add PMC clk device tree binding doc.
Date: Fri,  7 Jun 2013 10:34:22 +0200
Message-Id: <1370594119-5342-12-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370594119-5342-1-git-send-email-b.brezillon@overkiz.com>
References: <1370594119-5342-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11167238226716112044
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the documentation of the dt bindings used by at91 clks.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../devicetree/bindings/clock/at91-clock.txt       |  247 ++++++++++++++++++++
 1 file changed, 247 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/at91-clock.txt b/Documentation/devicetree/bindings/clock/at91-clock.txt
new file mode 100644
index 0000000..63c5d16
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/at91-clock.txt
@@ -0,0 +1,247 @@
+Device Tree Clock bindings for arch-at91
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be one of the following:
+	"atmel,at91rm9200-clk-main":
+		at91 main oscillator
+
+	"atmel,at91rm9200-clk-master" or
+	"atmel,at91sam9x5-clk-master":
+		at91 master clock
+
+	"atmel,at91sam9x5-clk-peripheral" or
+	"atmel,at91rm9200-clk-peripheral":
+		at91 peripheral clocks
+
+	"atmel,at91rm9200-clk-pll" or
+	"atmel,at91sam9g45-clk-pll" or
+	"atmel,at91sam9g20-clk-pllb" or
+	"atmel,sama5d3-clk-pll":
+		at91 pll clocks
+
+	"atmel,at91sam9x5-clk-plldiv":
+		at91 plla divisor
+
+	"atmel,at91rm9200-clk-programmable" or
+	"atmel,at91sam9g45-clk-programmable" or
+	"atmel,at91sam9x5-clk-programmable":
+		at91 programmable clocks
+
+	"atmel,at91sam9x5-clk-smd":
+		at91 SMD (Soft Modem) clock
+
+	"atmel,at91rm9200-clk-system":
+		at91 system clocks
+
+	"atmel,at91rm9200-clk-usb" or
+	"atmel,at91sam9x5-clk-usb":
+		at91 usb clock
+
+	"atmel,at91sam9x5-clk-utmi":
+		at91 utmi clock
+
+
+Required properties for main clock:
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks (optional if clock-frequency is provided) : shall be the slow clock
+	phandle. This clock is used to compute the main clock rate if
+	"clock-frequency" is not provided.
+- clock-frequency: the main oscillator frequency.Prefer the use of
+	"clock-frequency" over automatic clock rate computation.
+
+For example:
+	main: mainck {
+		compatible = "atmel,at91rm9200-clk-main";
+		#clock-cells = <0>;
+		clocks = <&ck32k>;
+		clock-frequency = <18432000>;
+	};
+
+Required properties for master clock:
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall be the master clock sources (see atmel datasheet) phandles.
+	e.g. "<&ck32k>, <&main>, <&plla>, <&pllb>".
+- characteristics : device tree node describing master clock characteristics.
+	You can find these characteristics in atmel's SoC datasheets.
+	* output : minimum and maximum clock frequency (two u32 fields).
+		e.g. output = <0 133000000>; <=> 0 to 133MHz.
+	* divisors : master clock divisors table (four u32 fields).
+		0 <=> reserved value.
+		e.g. divisors = <1 2 4 6>;
+	* have-div3-pres : some SoC use the reserved value 7 in the PRES field
+		as CLOCK_DIV3 (e.g sam9x5).
+
+For example:
+	mck: mck {
+		compatible = "atmel,at91rm9200-clk-master";
+		#clock-cells = <0>;
+		characteristics = {
+			output = <0 133000000>;
+			divisors = <1 2 4 0>;
+		};
+	};
+
+Required properties for peripheral clocks:
+- #clock-cells : from common clock binding; shall be set to 1. The second cell
+	is used to encode the peripheral id. Peripheral ids are defined in
+	atmel's SoC datasheets.
+- clocks : shall be the master clock phandle.
+	e.g. clocks = <&mck>;
+- ids : peripheral ids (u32 array).
+- clock-output-names : name of clocks. These are the name used during clock
+	registration.
+- "default-divisors" (optional, only available for
+	"atmel,at91sam9x5-clk-peripheral") : sam9x5 and sama5d3 SoC provides
+	configurable peripheral clock divisors. If you define this property
+	(u32 array), the default divisor will be applied when enabling
+	peripheral clock. If not provided the peripheral clock is not divided.
+
+For example:
+	periph: periphck {
+		compatible = "atmel,at91sam9x5-clk-peripheral";
+		#clock-cells = <1>;
+		clocks = <&mck>;
+		ids = <2 6 7>;
+		clock-output-names = "pioA_clk", "pioB_clk", "pioB_clk";
+		default-divisors = <1 2 2>;
+	};
+
+
+Required properties for pll clocks:
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall be the main clock phandle.
+- id : pll id
+	* 0 <=> plla
+	* 1 <=> pllb
+- characteristics : device tree node describing pll clock characteristics.
+	You can find these characteristics in atmel's SoC datasheets.
+	* input : minimum and maximum source clock frequency (two u32 fields).
+		e.g. input = <1 32000000>; <=> 1 to 32MHz.
+	* output : output frequency ranges.
+	* out: out field value for output frequency ranges.
+	* icpll (not available on some SoC): icpll field value for output
+		frequency ranges.
+
+For example:
+	plla: pllack {
+		compatible = "atmel,at91sam9g45-clk-pll";
+		#clock-cells = <0>;
+		clocks = <&main>;
+		id = <0>;
+		input = <2000000 32000000>;
+		output = <74500000 800000000
+			  69500000 750000000
+			  64500000 700000000
+			  59500000 650000000
+			  54500000 600000000
+			  49500000 550000000
+			  44500000 500000000
+			  40000000 450000000>;
+		out = <0 1 2 3 0 1 2 3>;
+		icpll = <0 0 0 0 1 1 1 1>;
+	};
+
+Required properties for plldiv clocks:
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall be the plla clock phandle.
+
+For example:
+	plladiv: plladivck {
+		compatible = "atmel,at91sam9x5-clk-plldiv";
+		#clock-cells = <0>;
+		clocks = <&plla>;
+	};
+
+Required properties for programmable clocks:
+- #clock-cells : from common clock binding; shall be set to 1. The second cell
+	is used to encode the programmable clock id.
+	Peripheral ids are in atmel's SoC
+	datasheets.
+- clocks : shall be the programmable clock source phandles.
+	e.g. clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+- ids : programmable clock ids (u32 array).
+- clock-output-names : name of clocks. These names are used during clock
+	registration.
+
+For example:
+	prog: progck {
+		compatible = "atmel,at91sam9g45-clk-programmable";
+		#clock-cells = <1>;
+		ids = <0 1>;
+		clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
+		clock-output-names = "prog0", "prog1";
+	};
+
+
+Required properties for smd clock:
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall be the smd clock source phandles.
+	e.g. clocks = <&plladiv>, <&utmi>;
+
+For example:
+	smd: smdck {
+		compatible = "atmel,at91sam9x5-clk-smd";
+		#clock-cells = <0>;
+		clocks = <&plladiv>, <&utmi>;
+	};
+
+Required properties for system clocks:
+- #clock-cells : from common clock binding; shall be set to 1. The second cell
+	is used to encode the system clock id (bit used in SCER/SCDR register).
+- clocks : shall be the system clock source phandle.
+	e.g. clocks = <&usb>;
+- ids : peripheral ids (u32 array).
+- clock-output-names : name of clocks. These names are used during clock
+	registration.
+
+For example:
+	system: systemck {
+		compatible = "atmel,at91rm9200-clk-system";
+		#clock-cells = <1>;
+		ids = <2 4 6 7 8 9 10>;
+		clocks = <&mck>, <&smd>, <&usb>, <&usb>,
+			 <&prog 0>, <&prog 1>, <&prog 2>;
+		clock-output-names = "ddrck", "smdck", "uhpck", "udpck",
+				     "pck0", "pck1", "pck2";
+	};
+
+
+Required properties for usb clock:
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall be the smd clock source phandles.
+	e.g. clocks = <&pllb>;
+- divisors (only available for "atmel,at91rm9200-clk-usb"):
+	usb clock divisor table.
+	e.g. divisors = <1 2 4 0>;
+- usbs0-unused (only available for "atmel,at91sam9x5-clk-usb"):
+	Some SoC (sam9n12) use usb source 0 to disable the usb clock.
+
+For example:
+	usb: usbck {
+		compatible = "atmel,at91sam9x5-clk-usb";
+		#clock-cells = <0>;
+		clocks = <&plladiv>, <&utmi>;
+	};
+
+	usb: usbck {
+		compatible = "atmel,at91rm9200-clk-usb";
+		#clock-cells = <0>;
+		clocks = <&pllb>;
+		divisors = <1 2 4 0>;
+	};
+
+
+Required properties for utmi clock:
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall be the main clock source phandle.
+
+For example:
+	utmi: utmick {
+		compatible = "atmel,at91sam9x5-clk-utmi";
+		#clock-cells = <0>;
+		clocks = <&main>;
+	};
-- 
1.7.9.5

