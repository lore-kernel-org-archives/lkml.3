Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaJTJEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:04:54 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:52678 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaJTJEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:04:50 -0400
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
Subject: [PATCH v4 3/3] ARM: dts: add rk3288 power-domain node
Date: Mon, 20 Oct 2014 02:03:43 -0700
Message-Id: <1413795824-3453-4-git-send-email-jinkun.hong@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com>
References: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jinkun.hong" <jinkun.hong@rock-chips.com>

Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>

---

Changes in v4: None
Changes in v3:
- Decomposition power-controller, changed to multiple controller
   (gpu-power-controller, hevc-power-controller)

Changes in v2:
- make pd_vio clocks all one entry per line and alphabetize.
- power: power-controller move back to pinctrl: pinctrl.

 arch/arm/boot/dts/rk3288.dtsi |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 5950b0a..6a9b313 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -592,4 +592,28 @@
 			};
 		};
 	};
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
 };
-- 
1.7.9.5

