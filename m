Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3CFJR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:17:29 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:61495 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017Ab3CFJRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:17:23 -0500
Message-ID: <1362561441.16460.164.camel@x61.thuisdomein>
Subject: [PATCH] [RESEND] score: Kconfig: drop nine selects and one entry
From: Paul Bolle <pebolle@tiscali.nl>
To: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 06 Mar 2013 10:17:21 +0100
In-Reply-To: <1321136297.20271.15.camel@x61.thuisdomein>
References: <1321136297.20271.15.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2013 09:17:22.0209 (UTC) FILETIME=[68B82110:01CE1A4B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config entries in the "System type" choice each use the same three
select statements. The Kconfig symbol SYS_SUPPORTS_32BIT_KERNEL is only
used by mips. The Kconfig symbol CPU_SCORE7 is used once, in an (almost)
empty Kconfig entry, and there are no uses of CONFIG_CPU_SCORE7. (This
means that the CPU_SCORE7 entry can also be dropped.) And
GENERIC_HAS_IOMAP is a typo. It should have been GENERIC_IOMAP. But
there's an entry for GENERIC_IOMAP that defaults to y, so no one
noticed.

So all selects from the config entries in this choice can be dropped.
And so can the CPU_SCORE7 config entry.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This patch was first sent over a year ago. Now I have reapplied it on
top of v3.9-rc1, which required a trivial adaption to context changes.

1) Still git grep tested only.

2) Please note that ARCH_SCORE7, MACH_SPCT6600, and SCORE_SIM still
aren't used anywhere else. There are also no uses of CONFIG_ARCH_SCORE7,
CONFIG_MACH_SPCT6600, and CONFIG_SCORE_SIM macros. Perhaps the entire
"System type" choice can be dropped.

 arch/score/Kconfig | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index e569aa1..382b996 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -22,28 +22,17 @@ choice
 
 config ARCH_SCORE7
 	bool "SCORE7 processor"
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
 
 config MACH_SPCT6600
 	bool "SPCT6600 series based machines"
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
 
 config SCORE_SIM
 	bool "Score simulator"
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select CPU_SCORE7
-	select GENERIC_HAS_IOMAP
+
 endchoice
 
 endmenu
 
-config CPU_SCORE7
-	bool
-
 config NO_DMA
 	bool
 	default y
-- 
1.7.11.7

