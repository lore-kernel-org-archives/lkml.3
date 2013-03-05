Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3CEMUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:20:23 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59548 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab3CEMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:20:22 -0500
Message-ID: <1362486020.16460.73.camel@x61.thuisdomein>
Subject: [PATCH v2] MIPS: Get rid of CONFIG_CPU_HAS_LLSC again
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Gorski <jogo@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 13:20:20 +0100
In-Reply-To: <CAOiHx=nzNVatEp0nyfZKU2p35+1kjrw6VsvZTP+QPJykWF3JAg@mail.gmail.com>
References: <1362477800.16460.69.camel@x61.thuisdomein>
	 <CAOiHx=nzNVatEp0nyfZKU2p35+1kjrw6VsvZTP+QPJykWF3JAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 12:20:20.0508 (UTC) FILETIME=[CDE1DDC0:01CE199B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f7ade3c168e4f437c11f57be012992bbb0e3075c ("MIPS: Get rid of
CONFIG_CPU_HAS_LLSC") did what it promised to do. But since then that
macro and its Kconfig symbol popped up again. Get rid of those again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This version fixes an embarrassing dangling "#endif" spotted by
Jonas. Thanks for that! Still untested.

1) The related commits are 1c773ea4dceff889c2f872343609a87ae0cfbf56
("MIPS: Netlogic: Add XLP makefiles and config") and
3070033a16edcc21688d5ea8967c89522f833862 ("MIPS: Add core files for MIPS
SEAD-3 development platform.").

 arch/mips/Kconfig                                        | 1 -
 arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h | 4 ----
 2 files changed, 5 deletions(-)

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
index d9c8284..b40f37f 100644
--- a/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
@@ -28,11 +28,7 @@
 /* #define cpu_has_prefetch	? */
 #define cpu_has_mcheck		1
 /* #define cpu_has_ejtag	? */
-#ifdef CONFIG_CPU_HAS_LLSC
-#define cpu_has_llsc		1
-#else
 #define cpu_has_llsc		0
-#endif
 /* #define cpu_has_vtag_icache	? */
 /* #define cpu_has_dc_aliases	? */
 /* #define cpu_has_ic_fills_f_dc ? */
-- 
1.7.11.7

