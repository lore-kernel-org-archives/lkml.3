Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaHDEy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:54:28 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:53651 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaHDEy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:54:26 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <749f13522f3755ff9768ab8dd384e2fc>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: mark yao <yzq@rock-chips.com>
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org,
        xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com,
        cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, mark yao <yzq@rock-chips.com>
Subject: [PATCH 6/9] Add devicetree bindings for Rockchip Soc LVDS
Date: Mon,  4 Aug 2014 12:53:13 +0800
Message-Id: <1407127993-1832-1-git-send-email-yzq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: mark yao <yzq@rock-chips.com>
---
 .../devicetree/bindings/video/rockchip-panel.txt   |   30 ++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/rockchip-panel.txt b/Documentation/devicetree/bindings/video/rockchip-panel.txt
index 9fc200a..f599806 100644
--- a/Documentation/devicetree/bindings/video/rockchip-panel.txt
+++ b/Documentation/devicetree/bindings/video/rockchip-panel.txt
@@ -50,3 +50,33 @@ Example:
 		};
 
 	};
+
+Rockchip RK3288 LVDS interface
+================================
+Required properties:
+-compatible: "rockchip,rk3288-lvds";
+
+- reg: physical base address of the controller and length
+- clocks: from common clock binding: handle to dp clock.
+	of memory mapped region.
+- clock-names: from common clock binding: Shall be "pclk_lvds".
+	pclk_lvds: for power domain, if it disable soc will power down
+- rockchip,grf: this soc should set GRF regs, so need get grf here.
+- rockchip,data-mapping: should be "vesa" or "jeida"
+	This describes how the color bits are laid out in the
+	serialized LVDS signal.
+- rockchip,data-width: should be <18> or <24>
+- rockchip,panel: required a panel node
+
+Example:
+	lvds: lvds@ff96c000 {
+		compatible = "rockchip,rk3288-lvds";
+		reg = <0xff96c000 0x4000>;
+		clocks = <&cru PCLK_LVDS_PHY>;
+		clock-names = "pclk_lvds";
+
+		rockchip,grf = <&grf>;
+		rockchip,data-mapping = "jeida";
+		rockchip,data-width = <24>;
+		rockchip,panel = <&panel>;
+	};
-- 
1.7.9.5


