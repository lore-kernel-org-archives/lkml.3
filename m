Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbbA2GmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:42:08 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48791 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbbA2GmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:42:06 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v5 06/13] ARM: at91: move select SRAM to ARCH_AT91
Date: Thu, 29 Jan 2015 14:39:39 +0800
Message-ID: <1422513579-24378-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
References: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the CONFIG_AT91_SLOW_CLOCK will be removed
to simply the PM config, so move select SRAM.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index c6740e3..6b9e685 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -25,6 +25,7 @@ config SOC_SAMA5
 	select MEMORY
 	select ATMEL_SDRAMC
 	select PHYLIB if NETDEVICES
+	select SRAM if PM
 
 menu "Atmel AT91 System-on-Chip"
 
@@ -82,6 +83,7 @@ config SOC_AT91RM9200
 	select CPU_ARM920T
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USB_CLK
+	select SRAM if PM
 
 config SOC_AT91SAM9
 	bool "AT91SAM9"
@@ -95,6 +97,7 @@ config SOC_AT91SAM9
 	select HAVE_AT91_UTMI
 	select HAVE_FB_ATMEL
 	select MEMORY
+	select SRAM if PM
 	help
 	  Select this if you are using one of those Atmel SoC:
 	    AT91SAM9260
@@ -119,7 +122,6 @@ comment "AT91 Feature Selections"
 
 config AT91_SLOW_CLOCK
 	bool "Suspend-to-RAM disables main oscillator"
-	select SRAM
 	depends on SUSPEND
 	help
 	  Select this if you want Suspend-to-RAM to save the most power
-- 
1.7.9.5

