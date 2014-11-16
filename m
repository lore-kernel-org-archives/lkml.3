Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKPUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:16:57 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55372 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaKPUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:16:53 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 3/3] ARM: meson: select PINCTRL_MESON and ARCH_REQUIRE_GPIOLIB
Date: Sun, 16 Nov 2014 21:14:16 +0100
Message-Id: <1416168856-12747-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
References: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the Meson pinctrl driver is built whenever Meson
support is enabled.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/mach-meson/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-meson/Kconfig b/arch/arm/mach-meson/Kconfig
index 2c1154e..1828711 100644
--- a/arch/arm/mach-meson/Kconfig
+++ b/arch/arm/mach-meson/Kconfig
@@ -1,7 +1,10 @@
 menuconfig ARCH_MESON
 	bool "Amlogic Meson SoCs" if ARCH_MULTI_V7
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_IRQ_CHIP
 	select ARM_GIC
+	select PINCTRL
+	select PINCTRL_MESON
 
 if ARCH_MESON
 
-- 
1.9.1

