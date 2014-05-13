Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbaEMKJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:09:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60802 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760058AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 015/182] ARM: dts: Keep G3D regulator always on for exynos5250-arndale
Date: Tue, 13 May 2014 11:26:07 +0200
Message-Id: <fa80816bbe970ccb38e4f9a6a771b2f09c3171e8.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bfeda827278f09f4db35877e5f1ca9c149ca2890 upstream.

Apparently, if G3D regulator is powered off, the SoC cannot enter low
power modes and just hangs. This patch fixes this by keeping the
regulator always on when the system is running, as suggested by Exynos 4
User's Manual in case of Exynos4210/4x12 SoCs (Exynos5250 UM does not
have such note, but observed behavior seems to confirm that it is true
for this SoC as well).

This fixes an issue preventing Arndale board from entering sleep mode
observed since commit

346f372f7b72a0 clk: exynos5250: Add CLK_IGNORE_UNUSED flag for pmu clock

that landed in kernel 3.10, which has fixed the clock driver to make the
SoC actually try to enter the sleep mode.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Tushar Behera <tushar.behera@linaro.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/exynos5250-arndale.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index cee55fa33731..47fa5aba20a1 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -286,6 +286,7 @@
 					regulator-name = "vdd_g3d";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
 					regulator-boot-on;
 					op_mode = <1>;
 				};
-- 
1.9.3

