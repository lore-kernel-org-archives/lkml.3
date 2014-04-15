Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaDOI0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:26:53 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:65065 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaDOI0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:26:49 -0400
Message-ID: <1397550407.1985.12.camel@x220>
Subject: [PATCH v2] ARM: spear: Remove references to PLAT_SPEAR_SINGLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Viresh Kumar <viresh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Martin Walch <walch.martin@web.de>, Richard Weinberger <richard@nod.at>,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 10:26:47 +0200
In-Reply-To: <1392153676.14317.8.camel@x220>
References: <1392153676.14317.8.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 08:26:47.0452 (UTC) FILETIME=[7129B5C0:01CF5884]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol PLAT_SPEAR_SINGLE briefly appeared during the v3.10
development cycle. It was removed in a merge commit before v3.10. A few
references to it were left in the tree, probably because they didn't
generate merge conflicts. Whatever it was, they're useless now and can
safely be removed.

Reported-by: Martin Walch <walch.martin@web.de>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) First version was broken: it left config ARCH_SPEAR_AUTO without its
bool type. This version is done on top of v3.15-rc1.

1) Still untested. 

 arch/arm/mach-spear/Kconfig | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
index 0786249b2832..bc8a11c53377 100644
--- a/arch/arm/mach-spear/Kconfig
+++ b/arch/arm/mach-spear/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig PLAT_SPEAR
 	bool "ST SPEAr Family" if ARCH_MULTI_V7 || ARCH_MULTI_V5
-	default PLAT_SPEAR_SINGLE
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_AMBA
 	select CLKSRC_MMIO
@@ -13,7 +12,7 @@ if PLAT_SPEAR
 
 config ARCH_SPEAR13XX
 	bool "ST SPEAr13xx"
-	depends on ARCH_MULTI_V7 || PLAT_SPEAR_SINGLE
+	depends on ARCH_MULTI_V7
 	select ARCH_HAS_CPUFREQ
 	select ARM_GIC
 	select GPIO_SPEAR_SPICS
@@ -41,7 +40,7 @@ endif #ARCH_SPEAR13XX
 
 config ARCH_SPEAR3XX
 	bool "ST SPEAr3xx"
-	depends on ARCH_MULTI_V5 || PLAT_SPEAR_SINGLE
+	depends on ARCH_MULTI_V5
 	depends on !ARCH_SPEAR13XX
 	select ARM_VIC
 	select PINCTRL
@@ -72,7 +71,7 @@ endif
 
 config ARCH_SPEAR6XX
 	bool "ST SPEAr6XX"
-	depends on ARCH_MULTI_V5 || PLAT_SPEAR_SINGLE
+	depends on ARCH_MULTI_V5
 	depends on !ARCH_SPEAR13XX
 	select ARM_VIC
 	help
@@ -85,7 +84,7 @@ config MACH_SPEAR600
 	  Supports ST SPEAr600 boards configured via the device-tree
 
 config ARCH_SPEAR_AUTO
-	def_bool PLAT_SPEAR_SINGLE
+	bool
 	depends on !ARCH_SPEAR13XX && !ARCH_SPEAR6XX
 	select ARCH_SPEAR3XX
 
-- 
1.9.0

