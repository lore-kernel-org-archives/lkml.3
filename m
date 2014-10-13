Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaJMUMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:12:17 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53737 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaJMUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:12:14 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/6] ARM: dts: rockchip: add intmem node for rk3288 smp support
Date: Mon, 13 Oct 2014 13:12:01 -0700
Message-Id: <1413231122-1770-6-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add intmem node des which is needed by platsmp.c

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v4:
- remove "rockchip,rk3288-pmu-sram" because we don't use it here

Changes in v3:
- remove 'enable-method' from this patch
- add compitable name "rockchip,rk3288-pmu-sram" for pmu-intmem

Changes in v2:
- adjust the alignment

 arch/arm/boot/dts/rk3288.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index bcfde19..726c5c7 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -441,6 +441,18 @@
 		status = "disabled";
 	};
 
+	bus_intmem@ff700000 {
+		compatible = "mmio-sram";
+		reg = <0xff700000 0x18000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0xff700000 0x18000>;
+		smp-sram@0 {
+			compatible = "rockchip,rk3066-smp-sram";
+			reg = <0x00 0x10>;
+		};
+	};
+
 	pmu: power-management@ff730000 {
 		compatible = "rockchip,rk3288-pmu", "syscon";
 		reg = <0xff730000 0x100>;
-- 
1.9.1

