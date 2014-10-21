Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbaJUX0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 19:26:16 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:58545 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaJUX0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 19:26:14 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <0a31dbc5dc0a98c5d46e5e1c153477b4>
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Xie <xxx@rock-chips.com>
Subject: [PATCH v4 5/6] ARM: rockchip: Add pmu-sram binding
Date: Tue, 21 Oct 2014 16:26:00 -0700
Message-Id: <1413933960-25839-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pmu-sram is used to store resume code, suspend/resume need get the
address of it. Therefore add a binding and documentation for it.

Signed-off-by: Tony Xie <xxx@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

Changes in v4: None
Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/arm/rockchip/pmu-sram.txt  |   15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt b/Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
new file mode 100644
index 0000000..77284c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/pmu-sram.txt
@@ -0,0 +1,15 @@
+Rockchip SRAM for pmu:
+------------------------------
+
+The sram of pmu is used to store the function of resume from maskrom(the 1st
+level loader).
+
+Required node properties:
+- compatible : should be "rockchip,rk3288-pmu-sram"
+- reg : physical base address and the size of the registers window
+
+Example:
+	pmu_intmem@ff720000 {
+		compatible = "rockchip,rk3288-pmu-sram", "mmio-sram";
+		reg = <0xff720000 0x4000>;
+	};
-- 
1.7.9.5

