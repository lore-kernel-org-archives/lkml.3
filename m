Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3GXELE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:11:04 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8520 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3GXEKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:10:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Jul 2013 21:10:14 -0700
From: Richard Zhao <rizhao@nvidia.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <broonie@kernel.org>, <gregkh@linuxfoundation.org>,
        <lgirdwood@gmail.com>, <rizhao@nvidia.com>, <linuxzsc@gmail.com>,
        <ldewangan@nvidia.com>, <dev@lynxeye.de>
Subject: [PATCH 5/9] spi: tegra20-sflash: move to generic dma DT binding
Date: Wed, 24 Jul 2013 12:09:58 +0800
Message-ID: <1374639002-16753-6-git-send-email-rizhao@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
References: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update binding doc.

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
---
 .../devicetree/bindings/spi/nvidia,tegra20-sflash.txt          | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt b/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
index 7b53da5..fa22d1b 100644
--- a/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
+++ b/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
@@ -4,8 +4,11 @@ Required properties:
 - compatible : should be "nvidia,tegra20-sflash".
 - reg: Should contain SFLASH registers location and length.
 - interrupts: Should contain SFLASH interrupts.
-- nvidia,dma-request-selector : The Tegra DMA controller's phandle and
-  request selector for this SFLASH controller.
+
+Optional properties:
+- dmas : The Tegra DMA controller's phandle and request selector for
+  this SFLASH controller.
+- dma-names : Should be "rx-tx".
 
 Recommended properties:
 - spi-max-frequency: Definition as per
@@ -17,7 +20,8 @@ spi@7000c380 {
 	compatible = "nvidia,tegra20-sflash";
 	reg = <0x7000c380 0x80>;
 	interrupts = <0 39 0x04>;
-	nvidia,dma-request-selector = <&apbdma 16>;
+	dmas = <&apbdma 16>;
+	dma-names = "rx-tx";
 	spi-max-frequency = <25000000>;
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
1.8.1.5

