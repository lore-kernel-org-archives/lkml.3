Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaLWN51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:57:27 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:37965 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755108AbaLWN5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:57:25 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] ASoC: dwc: Add documentation for I2S DT
Date: Tue, 23 Dec 2014 13:56:26 +0000
Message-Id: <ffbfb442b3ba3d7dec5a7ba3e0e596678d4e74e5.1419342218.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1419342218.git.Andrew.Jackson@arm.com>
References: <cover.1419342218.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1419342218.git.Andrew.Jackson@arm.com>
References: <cover.1419342218.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Add documentation for Designware I2S hardware block.  The block requires
one clock (for audio sampling) and DMA channels for receive and transmit.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 .../devicetree/bindings/sound/designware-i2s.txt   |   31 ++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/designware-i2s.txt

diff --git a/Documentation/devicetree/bindings/sound/designware-i2s.txt b/Documentation/devicetree/bindings/sound/designware-i2s.txt
new file mode 100644
index 0000000..7bb5424
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/designware-i2s.txt
@@ -0,0 +1,31 @@
+DesignWare I2S controller
+
+Required properties:
+ - compatible : Must be "snps,designware-i2s"
+ - reg : Must contain the I2S core's registers location and length
+ - clocks : Pairs of phandle and specifier referencing the controller's
+   clocks. The controller expects one clock: the clock used as the sampling
+   rate reference clock sample.
+ - clock-names : "i2sclk" for the sample rate reference clock.
+ - dmas: Pairs of phandle and specifier for the DMA channels that are used by
+   the core. The core expects one or two dma channels: one for transmit and
+   one for receive.
+ - dma-names : "tx" for the transmit channel, "rx" for the receive channel.
+
+For more details on the 'dma', 'dma-names', 'clock' and 'clock-names'
+properties please check:
+	* resource-names.txt
+	* clock/clock-bindings.txt
+	* dma/dma.txt
+
+Example:
+
+	soc_i2s: i2s@7ff90000 {
+		compatible = "snps,designware-i2s";
+		reg = <0x0 0x7ff90000 0x0 0x1000>;
+		clocks = <&scpi_i2sclk 0>;
+		clock-names = "i2sclk";
+		#sound-dai-cells = <0>;
+		dmas = <&dma0 5>;
+		dma-names = "tx";
+	};
-- 
1.7.1

