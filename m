Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaDXMDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:03:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46268 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaDXIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/182] ARM: dts: Keep G3D regulator always on for exynos5250-arndale
Date: Thu, 24 Apr 2014 09:48:57 +0100
Message-Id: <1398329507-5911-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Figa <t.figa@samsung.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/exynos5250-arndale.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index abc7272..e46bcd6 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -263,6 +263,7 @@
 					regulator-name = "vdd_g3d";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
 					regulator-boot-on;
 					op_mode = <1>;
 				};
-- 
1.9.1

