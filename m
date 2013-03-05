Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3CEKDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:03:24 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:60584 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819Ab3CEKDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:03:22 -0500
Message-ID: <1362477800.16460.69.camel@x61.thuisdomein>
Subject: [PATCH] MIPS: Get rid of CONFIG_CPU_HAS_LLSC again
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 11:03:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 10:03:20.0613 (UTC) FILETIME=[AA716D50:01CE1988]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f7ade3c168e4f437c11f57be012992bbb0e3075c ("MIPS: Get rid of
CONFIG_CPU_HAS_LLSC") did what it promised to do. But since then that
macro and its Kconfig symbol popped up again. Get rid of those again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) The related commits are 1c773ea4dceff889c2f872343609a87ae0cfbf56
("MIPS: Netlogic: Add XLP makefiles and config") and
3070033a16edcc21688d5ea8967c89522f833862 ("MIPS: Add core files for MIPS
SEAD-3 development platform.").

 arch/mips/Kconfig                                        | 1 -
 arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ae9c716..310f1e6 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1493,7 +1493,6 @@ config CPU_XLP
 	select CPU_SUPPORTS_32BIT_KERNEL
 	select CPU_SUPPORTS_64BIT_KERNEL
 	select CPU_SUPPORTS_HIGHMEM
-	select CPU_HAS_LLSC
 	select WEAK_ORDERING
 	select WEAK_REORDERING_BEYOND_LLSC
 	select CPU_HAS_PREFETCH
diff --git a/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h b/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
index d9c8284..2a945b4 100644
--- a/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
@@ -28,9 +28,6 @@
 /* #define cpu_has_prefetch	? */
 #define cpu_has_mcheck		1
 /* #define cpu_has_ejtag	? */
-#ifdef CONFIG_CPU_HAS_LLSC
-#define cpu_has_llsc		1
-#else
 #define cpu_has_llsc		0
 #endif
 /* #define cpu_has_vtag_icache	? */
-- 
1.7.11.7

