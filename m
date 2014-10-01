Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaJAVbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:31:31 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39737 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaJAVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:31:28 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 1/6] ARM: meson: add meson8 machine definition
Date: Wed,  1 Oct 2014 23:29:41 +0200
Message-Id: <1412198986-26534-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
References: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a machine definition for Amlogic Meson8 SoCs.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/mach-meson/Kconfig | 5 +++++
 arch/arm/mach-meson/meson.c | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/mach-meson/Kconfig b/arch/arm/mach-meson/Kconfig
index 2c1154e..b289e8e 100644
--- a/arch/arm/mach-meson/Kconfig
+++ b/arch/arm/mach-meson/Kconfig
@@ -10,4 +10,9 @@ config MACH_MESON6
 	default ARCH_MESON
 	select MESON6_TIMER
 
+config MACH_MESON8
+	bool "Amlogic Meson8 SoCs support"
+	default ARCH_MESON
+	select MESON6_TIMER
+
 endif
diff --git a/arch/arm/mach-meson/meson.c b/arch/arm/mach-meson/meson.c
index 5ee064f..e95d6ae 100644
--- a/arch/arm/mach-meson/meson.c
+++ b/arch/arm/mach-meson/meson.c
@@ -21,7 +21,15 @@ static const char * const m6_common_board_compat[] = {
 	NULL,
 };
 
+static const char * const m8_common_board_compat[] = {
+	"amlogic,meson8",
+	NULL,
+};
+
 DT_MACHINE_START(AML8726_MX, "Amlogic Meson6 platform")
 	.dt_compat	= m6_common_board_compat,
 MACHINE_END
 
+DT_MACHINE_START(MESON8, "Amlogic Meson8 platform")
+	.dt_compat	= m8_common_board_compat,
+MACHINE_END
-- 
1.9.1

