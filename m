Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbbA0M3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:29:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35338 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbbA0MTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jisheng Zhang <jszhang@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 094/126] ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2 host
Date: Tue, 27 Jan 2015 12:16:39 +0000
Message-Id: <1422361031-19364-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@marvell.com>

commit 96ed6046d3bf1113de3bdbd6dbb7f40e6d0ae0ef upstream.

On BG2Q, the sdhci2 host uses nfcecc for "io" clk and nfc for "core" clk.
The shdci2 can't work without this patch due to the "core" clk is gated.

Fixes: 0d859a6a9d14 ("ARM: dts: berlin: add the SDHCI nodes for the BG2Q")
Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 635a16a64cb4..39b181dc6fab 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -82,7 +82,8 @@
 			compatible = "mrvl,pxav3-mmc";
 			reg = <0xab1000 0x200>;
 			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&chip CLKID_SDIO1XIN>;
+			clocks = <&chip CLKID_NFC_ECC>, <&chip CLKID_NFC>;
+			clock-names = "io", "core";
 			status = "disabled";
 		};
 
-- 
2.1.4

