Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaG0MWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 08:22:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbaG0MW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 08:22:26 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH 2/3] ARM: dts: exynos: Add PMU to Exynos5410
Date: Sun, 27 Jul 2014 14:22:04 +0200
Message-Id: <1406463725-4208-3-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406463725-4208-1-git-send-email-afaerber@suse.de>
References: <1406463725-4208-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos initialization code now relies on obtaining the PMU address,
so prepare a PMU node for Exynos5410.

Fixes: fce9e5bb2526 ("ARM: EXYNOS: Add support for mapping PMU base address via DT")
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 arch/arm/boot/dts/exynos5410.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
index 9d0b8cc1409c..790d4886d7b5 100644
--- a/arch/arm/boot/dts/exynos5410.dtsi
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -91,6 +91,11 @@
 			reg = <0x10000000 0x100>;
 		};
 
+		pmu_system_controller: system-controller@10040000 {
+			compatible = "samsung,exynos5410-pmu", "syscon";
+			reg = <0x10040000 0x5000>;
+		};
+
 		mct: mct@101C0000 {
 			compatible = "samsung,exynos4210-mct";
 			reg = <0x101C0000 0xB00>;
-- 
1.9.3

