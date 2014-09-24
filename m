Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaIXPjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:39:41 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65025 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaIXPiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:38:05 -0400
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Sunil Goutham <sgoutham@cavium.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tirumalesh Chalamarla <tchalamarla@cavium.com>,
        Robert Richter <rrichter@cavium.com>, devicetree@vger.kernel.org
Subject: [PATCH 2/6] GICv3: Add ITS entry to THUNDER dts
Date: Wed, 24 Sep 2014 17:37:44 +0200
Message-Id: <1411573068-12952-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411573068-12952-1-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tirumalesh Chalamarla <tchalamarla@cavium.com>

The PCIe host controller uses MSIs provided by GICv3 ITS. Enable it on
Thunder SoCs by adding an entry to DT.

Signed-off-by: Tirumalesh Chalamarla <tchalamarla@cavium.com>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/boot/dts/thunder-88xx.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/thunder-88xx.dtsi b/arch/arm64/boot/dts/thunder-88xx.dtsi
index d8c0bdc51882..9cb7cf94284a 100644
--- a/arch/arm64/boot/dts/thunder-88xx.dtsi
+++ b/arch/arm64/boot/dts/thunder-88xx.dtsi
@@ -376,10 +376,19 @@
 		gic0: interrupt-controller@8010,00000000 {
 			compatible = "arm,gic-v3";
 			#interrupt-cells = <3>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges;
 			interrupt-controller;
 			reg = <0x8010 0x00000000 0x0 0x010000>, /* GICD */
 			      <0x8010 0x80000000 0x0 0x600000>; /* GICR */
 			interrupts = <1 9 0xf04>;
+
+			its: gic-its@8010,00020000 {
+				compatible = "arm,gic-v3-its";
+				msi-controller;
+				reg = <0x8010 0x20000 0x0 0x200000>;
+			};
 		};
 
 		uaa0: serial@87e0,24000000 {
-- 
2.1.0

