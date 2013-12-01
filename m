Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3LAKMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 05:12:31 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44140 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3LAKM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 05:12:28 -0500
From: Alex Ling <kasimling@gmail.com>
To: ben-linux@fluff.org, kgene.kim@samsung.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alex Ling <kasimling@gmail.com>
Subject: [PATCH 1/1] ARM: dts: Add missing clock names for exynos4412 dwmmc node
Date: Sun,  1 Dec 2013 18:11:47 +0800
Message-Id: <1385892707-25063-1-git-send-email-kasimling@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds "biu" and "ciu" clock names for exynos4412 dwmmc
node. Without this patch, dwmmc host driver will skip enabling the
two clocks and it will break dwmmc host function on exynos4412.
Tested on FriendlyARM TINY4412 board.

Signed-off-by: Alex Ling <kasimling@gmail.com>
---
 arch/arm/boot/dts/exynos4412.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index e743e67..67bef99 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -67,5 +67,7 @@
 		interrupts = <0 77 0>;
 		#address-cells = <1>;
 		#size-cells = <0>;
+		clocks = <&clock 301>, <&clock 149>;
+		clock-names = "biu", "ciu";
 	};
 };
-- 
1.7.9.5

