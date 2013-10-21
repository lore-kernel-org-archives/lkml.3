Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3JUOTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49971 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3JUOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:45 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-45-526538004614
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 11/12] arm: dts: exynos4: add HDMI devices
Date: Mon, 21 Oct 2013 16:18:30 +0200
Message-id: <1382365111-6533-12-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAV0Gi9Qgg80XrS3mHznHanHl63s2
	i0n3J7BY9C64ymZx4WkPm8XZpjfsFpd3zWGzmHF+H5PF0wkX2SymLDrManH4TTurxYzJL9ks
	1s94zWIxr/0lq8WxGUsYHfg97lzbw+Zxv/s4k0ffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1
	SN8ugSvj55wtTAWveCs23DnE1MC4lLuLkZNDQsBEouPCHzYIW0ziwr31QDYXh5DAIkaJq0/3
	sEI4XUwSncv6GUGq2IA6ji35DGaLCCRK/Gq+ywxSxCxwiElid8sUZpCEsICFxNRpG9lBbBYB
	VYk/n1qBGjg4eAU8JC6954HYJi/x9H4f2GZOoPCpl2vBZgoJuEu8+zaPZQIj7wJGhlWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwWH6TGoH48oGi0OMAhyMSjy8AS4pQUKsiWXFlbmHGCU4
	mJVEeKtMU4OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1
	MB6aaebpKfwkNpF1f3jMN+f4UCuBLRZaUQESiglq6Xm+XDKXT/W8k3ZyWPb3tbH4XqW3M3Zd
	ZWDb7br6kqJK1rMNuSdXhL3Zn7RMPC/UyfWpUHfGyUqG1d7X/i+vCQw0f/fF40l9jP6zGeVP
	7ZZ8tpm5Z6+o+uqg/Z9WCJkc/vPeuU/m7uJudSWW4oxEQy3mouJEALOFBRhPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT nodes for HDMI related devices on SoCs from Exynos4 family.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi    |   27 +++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi |    4 ++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index a5f6b8b..a5df9fe 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -522,4 +522,31 @@
 		samsung,power-domain = <&pd_lcd0>;
 		status = "disabled";
 	};
+
+	hdmi_phy: hdmi-phy@10020700 {
+		compatible = "simple-phy";
+		reg = <0x10020700 0x4>;
+		mask = <1>;
+		#phy-cells = <0>;
+	};
+
+	hdmi: hdmi@12D00000 {
+		reg = <0x12D00000 0x70000>;
+		interrupts = <0 92 0>;
+		clock-names = "hdmi", "sclk_hdmi", "sclk_pixel", "sclk_hdmiphy";
+		clocks = <&clock 271>, <&clock 136>, <&clock 139>, <&clock 21>;
+		phys = <&hdmi_phy>;
+		phy-names = "hdmiphy";
+		status = "disabled";
+		samsung,power-domain = <&pd_tv>;
+	};
+
+	mixer: mixer@12C10000 {
+		compatible = "samsung,exynos4-mixer";
+		interrupts = <0 91 0>;
+		reg = <0x12C10000 0x2100>, <0x12c00000 0x300>;
+		clock-names = "mixer", "sclk_hdmi", "vp", "sclk_dac", "sclk_mixer";
+		clocks = <&clock 269>, <&clock 136>, <&clock 268>, <&clock 138>, <&clock 137>;
+		samsung,power-domain = <&pd_tv>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 057d682..75fd845 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -155,4 +155,8 @@
 			samsung,lcd-wb;
 		};
 	};
+
+	hdmi: hdmi@12D00000 {
+		compatible = "samsung,exynos4210-hdmi";
+	};
 };
-- 
1.7.9.5

