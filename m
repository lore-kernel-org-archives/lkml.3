Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaGKOGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:06:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbaGKOFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:53 -0400
X-AuditID: cbfee61b-f79f86d00000144c-4d-53bfef3f88d9
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH/RFC v4 21/21] ARM: dts: add aat1290 current regulator device
 node
Date: Fri, 11 Jul 2014 16:04:24 +0200
Message-id: <1405087464-13762-22-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xoK79+/3BBjeXaltsnLGe1WL+kXOs
	Fr1XnzNa9C64ymZxtukNu8XlXXPYLLa+Wcdo0bNhK6sDh0ffllWMHp83yQUwRXHZpKTmZJal
	FunbJXBlzHyxnqVgIVfF8lc3WBoYl3B0MXJySAiYSHw7dJUVwhaTuHBvPVsXIxeHkMB0Rom3
	h5pYIJx2JomzjY3sIFVsAoYSP1+8ZgKxRQTKJXrePwPrYBboYpSY8/cdI0hCWCBYorV7KQuI
	zSKgKnFucxcbiM0r4Cmx+sIcoGYOoHUKEnMm2YCEOYHCB/tvgpUICXhIPFx7gn0CI+8CRoZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEh9Ex6B+OqBotDjAIcjEo8vCfW7AsWYk0sK67M
	PcQowcGsJMJ79c3+YCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2Cy
	TBycUg2M1dM21YpZ3Pxtu05DusZ5zaRFK/Se37Bse7Ls7X6BNbqlCjESN8//dhKSn/dN8ek7
	18UHf08693HpgavrfPdmbBcMd+Zskoozrr7WqPV/0+l7izPvz23d011gpxMdyF4Q23x5b/7n
	aRM4TYwt4hz5JmWp/du5wDRE8wezctRWppmpked21KmbKLEUZyQaajEXFScCAGhgZLYdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device node for AAT1290 1.5A Step-Up Current Regulator
for Flash LEDs along with flash_muxes node containing
information about a multiplexer that is used for switching
between software and external strobe signal source.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 7787844..cbb76ba 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -785,4 +785,28 @@
 		pulldown-ohm = <100000>; /* 100K */
 		io-channels = <&adc 2>;  /* Battery temperature */
 	};
+
+	flash_muxes {
+		flash_mux1: mux1 {
+			gpios = <&gpj1 0 0>;
+		};
+	};
+
+	aat1290 {
+		compatible = "skyworks,aat1290";
+		gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+		flash-timeout = <1940000>;
+		status = "okay";
+
+		gate-software-strobe {
+			mux = <&flash_mux1>;
+			mux-line-id = <0>;
+		};
+
+		gate-external-strobe {
+			strobe-provider = <&s5c73m3_spi>;
+			mux = <&flash_mux1>;
+			mux-line-id = <1>;
+		};
+	};
 };
-- 
1.7.9.5

