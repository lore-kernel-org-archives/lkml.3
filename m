Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaEDQRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:17:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaEDPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 3.10 09/86] ARM: dts: Keep G3D regulator always on for exynos5250-arndale
Date: Sun,  4 May 2014 11:40:44 -0400
Message-Id: <20140504154141.683846343@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5250-arndale.dts |    1 +
 1 file changed, 1 insertion(+)

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


