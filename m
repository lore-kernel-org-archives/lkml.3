Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaICUou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:44:50 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64506 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbaICUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:44:46 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Cc: Alexandru Stan <amstan@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        broonie@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] dt-bindings: spi/rockchip: Mark DMA as optional
Date: Wed,  3 Sep 2014 13:44:27 -0700
Message-Id: <1409777067-17422-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409777067-17422-1-git-send-email-dianders@chromium.org>
References: <1409777067-17422-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rockchip SPI controller works fine without DMA (aside from a few
warnings).  The DMA property even implies this, saying:

  DMA request names should include "tx" and "rx" if present.

Officially mark the properties as optional.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 Documentation/devicetree/bindings/spi/spi-rockchip.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-rockchip.txt b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
index 7bab355..467dec4 100644
--- a/Documentation/devicetree/bindings/spi/spi-rockchip.txt
+++ b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
@@ -16,11 +16,15 @@ Required Properties:
 - clocks: Must contain an entry for each entry in clock-names.
 - clock-names: Shall be "spiclk" for the transfer-clock, and "apb_pclk" for
 			   the peripheral clock.
+- #address-cells: should be 1.
+- #size-cells: should be 0.
+
+Optional Properties:
+
 - dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
 		Documentation/devicetree/bindings/dma/dma.txt
 - dma-names: DMA request names should include "tx" and "rx" if present.
-- #address-cells: should be 1.
-- #size-cells: should be 0.
+
 
 Example:
 
-- 
2.1.0.rc2.206.gedb03e5

