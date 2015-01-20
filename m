Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbbATIUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:20:18 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:32778 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293AbbATIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:20:16 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 05/12] ARM: at91: move select SRAM to ARCH_AT91
Date: Tue, 20 Jan 2015 16:16:58 +0800
Message-ID: <1421741825-18226-6-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the CONFIG_AT91_SLOW_CLOCK will be removed
to simply the PM config, so move select SRAM.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 56dcede..7d5e201 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -6,6 +6,7 @@ config ARCH_AT91
 	select PINCTRL
 	select PINCTRL_AT91
 	select USE_OF
+	select SRAM if PM
 	bool
 
 menuconfig SOC_SAM_V7
@@ -128,7 +129,6 @@ comment "AT91 Feature Selections"
 
 config AT91_SLOW_CLOCK
 	bool "Suspend-to-RAM disables main oscillator"
-	select SRAM
 	depends on SUSPEND
 	help
 	  Select this if you want Suspend-to-RAM to save the most power
-- 
1.7.9.5

