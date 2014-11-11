Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaKKHUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:20:17 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:56398 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaKKHUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:20:13 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: linus.walleij@linaro.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <a96c6c0eba4605eff9324fd3d0323159>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, fzf@rock-chips.com,
        cf@rock-chips.com, caesar.wang@rock-chips.com,
        Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Subject: [PATCH v10 1/3] dt-bindings: add document of Rockchip power domain
Date: Tue, 11 Nov 2014 15:19:50 +0800
Message-Id: <1415690392-9278-2-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415690392-9278-1-git-send-email-caesar.wang@rock-chips.com>
References: <1415690392-9278-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the necessary binding documentation for the power domain
found on Rockchip Socs.

Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>

---

Changes in v10: None
Changes in v9:
    - add document decription

Changes in v8:
    - document go back to v2

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
    - DT structure has changed

Changes in v2:
    - move clocks to "optional"

 .../bindings/arm/rockchip/power_domain.txt         | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/power_domain.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/power_domain.txt b/Documentation/devicetree/bindings/arm/rockchip/power_domain.txt
new file mode 100644
index 0000000..3e74e6d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/power_domain.txt
@@ -0,0 +1,48 @@
+* Rockchip Power Domains
+
+Rockchip processors include support for multiple power domains which can be
+powered up/down by software based on different application scenes to save power.
+
+Required properties for power domain controller:
+- compatible: should be one of the following.
+    * rockchip,rk3288-power-controller - for rk3288 type power domain.
+- #power-domain-cells: Number of cells in a power-domain specifier.
+		       should be 1.
+- rockchip,pmu: phandle referencing a syscon providing the pmu registers
+- #address-cells: should be 1.
+- #size-cells: should be 0.
+
+Required properties for power domain sub nodes:
+- reg: index of the power domain, should use macros in:
+    *  include/dt-bindings/power-domain/rk3288.h - for rk3288 type power domain.
+- clocks (optional): phandles to clocks which need to be enabled while power domain
+          switches state.
+
+Example:
+
+	power: power-controller {
+	       compatible = "rockchip,rk3288-power-controller";
+	       #power-domain-cells = <1>;
+	       rockchip,pmu = <&pmu>;
+               #address-cells = <1>;
+               #size-cells = <0>;
+
+	       pd_gpu {
+	               reg = <RK3288_PD_GPU>;
+	               clocks = <&cru ACLK_GPU>;
+	       };
+	};
+
+Node of a device using power domains must have a power-domains property,
+containing a phandle to the power device node and an index specifying which
+power domain to use.
+The index should use macros in:
+   * include/dt-bindings/power-domain/rk3288.h - for rk3288 type power domain.
+
+Example of the node using power domain:
+
+	node {
+		/* ... */
+		power-domains = <&power RK3288_PD_GPU>;
+		/* ... */
+	};
-- 
1.9.1


