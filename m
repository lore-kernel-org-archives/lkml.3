Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaLAIxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:53:05 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:32839 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaLAIxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:53:02 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Tony Xie <xxx@rock-chips.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 2/4] ARM: rockchip: Add pmu-sram binding
Date: Mon,  1 Dec 2014 16:52:18 +0800
Message-Id: <1417423940-1669-3-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pmu-sram is used to store resume code, suspend/resume need get the
address of it. Therefore add a binding and documentation for it.

Signed-off-by: Tony Xie <xxx@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>

---

Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6:
- change pmu_intmem@ff720000 to sram@ff720000

Changes in v5:
- change the size of sram in example

Changes in v4: None
Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/arm/rockchip/pmu-sram.txt        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt b/Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
new file mode 100644
index 0000000..6b42fda
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
@@ -0,0 +1,16 @@
+Rockchip SRAM for pmu:
+------------------------------
+
+The sram of pmu is used to store the function of resume from maskrom(the 1st
+level loader). This is a common use of the "pmu-sram" because it keeps power
+even in low power states in the system.
+
+Required node properties:
+- compatible : should be "rockchip,rk3288-pmu-sram"
+- reg : physical base address and the size of the registers window
+
+Example:
+	sram@ff720000 {
+		compatible = "rockchip,rk3288-pmu-sram", "mmio-sram";
+		reg = <0xff720000 0x1000>;
+	};
-- 
1.9.1

