Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbaJVHzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:55:06 -0400
Received: from mail-pd0-f195.google.com ([209.85.192.195]:35187 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaJVHzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:55:01 -0400
From: "jinkun.hong" <jinkun.hong@rock-chips.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: [PATCH v6 2/3] dt-bindings: add document of Rockchip power domain
Date: Wed, 22 Oct 2014 00:53:43 -0700
Message-Id: <1413964424-7599-3-git-send-email-jinkun.hong@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413964424-7599-1-git-send-email-jinkun.hong@rock-chips.com>
References: <1413964424-7599-1-git-send-email-jinkun.hong@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jinkun.hong" <jinkun.hong@rock-chips.com>

Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>

---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- DT structure has changed

Changes in v2:
- move clocks to "optional"

 .../bindings/arm/rockchip/power_domain.txt         |   46 ++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/power_domain.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/power_domain.txt b/Documentation/devicetree/bindings/arm/rockchip/power_domain.txt
new file mode 100644
index 0000000..f8357b3
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/power_domain.txt
@@ -0,0 +1,46 @@
+* Rockchip Power Domains
+
+Rockchip processors include support for multiple power domains which can be
+powered up/down by software based on different application scenes to save power.
+
+Required properties for power domain controller:
+- compatible: should be one of the following.
+    * rockchip,rk3288-power-gpu - for rk3288 type gpu power domain.
+    * rockchip,rk3288-power-hevc - for rk3288 type hevc power domain.
+    * rockchip,rk3288-power-video - for rk3288 type video power domain.
+    * rockchip,rk3288-power-vio - for rk3288 type vio power domain.
+- rockchip,pmu: phandle referencing a syscon providing the pmu registers
+- #power-domain-cells: Number of cells in a power-domain specifier.
+		       should be 0.
+
+Example:
+
+	gpu_power: gpu-power-controller {
+		compatible = "rockchip,rk3288-power-gpu";
+		rockchip,pmu = <&pmu>;
+		#power-domain-cells = <0>;
+	};
+
+	hevc_power: hevc-power-controller {
+		compatible = "rockchip,rk3288-power-hevc";
+		rockchip,pmu = <&pmu>;
+		#power-domain-cells = <0>;
+	};
+
+	video_power: video-power-controller {
+		compatible = "rockchip,rk3288-power-video";
+		rockchip,pmu = <&pmu>;
+		#power-domain-cells = <0>;
+	};
+
+	vio_power: vio-power-controller {
+		compatible = "rockchip,rk3288-power-vio";
+		rockchip,pmu = <&pmu>;
+		#power-domain-cells = <0>;
+	};
+
+	gpu: gpu@0xffa30000 {
+		...
+		power-domains = <&gpu_power>;
+		...
+	};
-- 
1.7.9.5

