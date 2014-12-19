Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaLSQTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:19:13 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:36553 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751142AbaLSQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:19:08 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] ASoC: dwc: Add documentation for I2S DT
Date: Fri, 19 Dec 2014 16:18:09 +0000
Message-Id: <2842090b2c7a8a98aed0cfa02addcef0b2e8ec6b.1418826016.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418826016.git.Andrew.Jackson@arm.com>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1418826016.git.Andrew.Jackson@arm.com>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Add documentation for Designware I2S hardware block.  The block requires
two clocks (one for audio sampling, the other for APB) and DMA channels
for receive and transmit.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 .../devicetree/bindings/sound/designware-i2s.txt   |   32 ++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/designware-i2s.txt

diff --git a/Documentation/devicetree/bindings/sound/designware-i2s.txt b/Documentation/devicetree/bindings/sound/designware-i2s.txt
new file mode 100644
index 0000000..cdee591
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/designware-i2s.txt
@@ -0,0 +1,32 @@
+DesignWare I2S controller
+
+Required properties:
+ - compatible : Must be "snps,designware-i2s"
+ - reg : Must contain I2S core's registers location and length
+ - clocks : Pairs of phandle and specifier referencing the controller's clocks.
+   The controller expects two clocks, the clock used for the APB interface and
+   the clock used as the sampling rate reference clock sample.
+ - clock-names : "apb_plck" for the clock to the APB interface, "i2sclk" for the sample
+   rate reference clock.
+ - dmas: Pairs of phandle and specifier for the DMA channels that are used by
+   the core. The core expects one or two dma channels, one for transmit and one for
+   receive.
+ - dma-names : "tx" for the transmit channel, "rx" for the receive channel.
+
+For more details on the 'dma', 'dma-names', 'clock' and 'clock-names' properties
+please check:
+	* resource-names.txt
+	* clock/clock-bindings.txt
+	* dma/dma.txt
+
+Example:
+
+	soc_i2s: i2s@7ff90000 {
+		compatible = "snps,designware-i2s";
+		reg = <0x0 0x7ff90000 0x0 0x1000>;
+		clocks = <&scpi_i2sclk 0>, <&soc_refclk100mhz>;
+		clock-names = "i2sclk", "apb_pclk";
+		#sound-dai-cells = <0>;
+		dmas = <&dma0 5>;
+		dma-names = "tx";
+	};
-- 
1.7.1

