Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3IQMpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:45:35 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63923 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3IQMoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:11 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 09/11] ARM: dts: AM33XX: Associate SRAM with MPU and mark it exec
Date: Tue, 17 Sep 2013 05:43:35 -0700
Message-Id: <1379421817-15759-10-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SRAM is for use by the MPU. Marking it as such makes it
easier for PM initialization code to locate the SRAM in order to
load a PIE section into it.

Additionally, set the map-exec flag to allow code to be run
from SRAM. This is necessary for suspend/resume.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 302463d..20942a2 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -62,6 +62,7 @@
 		mpu {
 			compatible = "ti,omap3-mpu";
 			ti,hwmods = "mpu";
+			sram = <&ocmcram>;
 		};
 	};
 
@@ -507,6 +508,7 @@
 		ocmcram: ocmcram@40300000 {
 			compatible = "mmio-sram";
 			reg = <0x40300000 0x10000>; /* 64k */
+			map-exec;
 		};
 
 		wkup_m3: wkup_m3@44d00000 {
-- 
1.8.3.2

