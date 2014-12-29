Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaL2Xel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:34:41 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41134 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaL2Xc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:28 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 07/12] ARM: imx: depend MXC debug board on 3DS machines
Date: Tue, 30 Dec 2014 00:32:10 +0100
Message-Id: <1419895935-22966-8-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depend the MXC debug board on machines which actually support it.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
This configuration appeared lonely when I enabled ARCH_MULTI_V7M.
Afaik, the selection of it only makes sense with one of the supported
boards...

 arch/arm/mach-imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 3c5859e..96c8eb8 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -21,6 +21,7 @@ config MXC_AVIC
 
 config MXC_DEBUG_BOARD
 	bool "Enable MXC debug board(for 3-stack)"
+	depends on CONFIG_MACH_MX27_3DS || CONFIG_MACH_MX31_3DS || CONFIG_MACH_MX35_3DS
 	help
 	  The debug board is an integral part of the MXC 3-stack(PDK)
 	  platforms, it can be attached or removed from the peripheral
-- 
2.2.1

