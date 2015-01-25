Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbbAYSpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:45:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbbAYSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jisheng Zhang <jszhang@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 3.18 094/183] ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2 host
Date: Sun, 25 Jan 2015 10:06:56 -0800
Message-Id: <20150125180814.253733564@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@marvell.com>

commit 96ed6046d3bf1113de3bdbd6dbb7f40e6d0ae0ef upstream.

On BG2Q, the sdhci2 host uses nfcecc for "io" clk and nfc for "core" clk.
The shdci2 can't work without this patch due to the "core" clk is gated.

Fixes: 0d859a6a9d14 ("ARM: dts: berlin: add the SDHCI nodes for the BG2Q")
Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/berlin2q.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -83,7 +83,8 @@
 			compatible = "mrvl,pxav3-mmc";
 			reg = <0xab1000 0x200>;
 			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&chip CLKID_SDIO1XIN>;
+			clocks = <&chip CLKID_NFC_ECC>, <&chip CLKID_NFC>;
+			clock-names = "io", "core";
 			status = "disabled";
 		};
 


