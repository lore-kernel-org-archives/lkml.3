Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaGHXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:25:27 -0400
Received: from gloria.sntech.de ([95.129.55.99]:45340 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaGHXZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:25:25 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?utf-8?B?ZWRkaWUo6JSh5p6rKQ==?= <cf@rock-chips.com>,
        huangtao@rock-chips.com
Subject: [PATCH 2/2] dt-bindings: document Rockchip saradc
Date: Wed, 09 Jul 2014 01:26:46 +0200
Message-ID: <3591595.sBj6Zqo42A@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <2959154.xc8BQActsn@diego>
References: <2959154.xc8BQActsn@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the necessary binding documentation for the saradc found in all recent
processors from Rockchip.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../bindings/iio/adc/rockchip-saradc.txt           | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt

diff --git a/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
new file mode 100644
index 0000000..603ac9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
@@ -0,0 +1,28 @@
+Rockhip Successive Approximation Register (SAR) A/D Converter bindings
+
+Required properties:
+- compatible: Should be "rockchip,saradc"
+- reg: physical base address of the controller and length of memory mapped
+       region.
+- interrupts: The interrupt number to the cpu. The interrupt specifier format
+              depends on the interrupt controller.
+- clocks: Must contain an entry for each entry in clock-names.
+- clock-names: Shall be "saradc" for the converter-clock, and "apb_pclk" for
+               the peripheral clock.
+- vref-supply: The regulator supply ADC refrence voltage.
+- #io-channel-cells: Should be 1, see ../iio-bindings.txt
+
+Optional properties :
+- clock-frequency : converter frequency in Hz. If omitted, 1MHz is used.
+
+Example:
+	saradc: saradc@2006c000 {
+		compatible = "rockchip,saradc";
+		reg = <0x2006c000 0x100>;
+		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_SARADC>, <&cru PCLK_SARADC>;
+		clock-names = "saradc", "apb_pclk";
+		#io-channel-cells = <1>;
+		vref-supply = <&vcc18>;
+		clock-frequency = <1000000>;
+	};
-- 
1.9.0


