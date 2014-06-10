Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaFJM0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:26:00 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35215 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaFJMZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:25:59 -0400
Message-ID: <5396F950.1010707@gmail.com>
Date: Tue, 10 Jun 2014 20:25:52 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: liqin.linux@gmail.com, lennox.wu@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dave.hansen@linux.intel.com, akpm@linux-foundation.org,
        davidlohr@hp.com, David Miller <davem@davemloft.net>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, ddstreet@ieee.org
Subject: [PATCH] lib/Kconfig.debug: Let FRAME_POINTER exclude SCORE, just
 like exclude most of other architectures
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The related warning:
  scripts/kconfig/conf --allmodconfig Kconfig
  warning: (FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK && LOCKDEP) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || ARCH_WANT_FRAME_POINTERS)

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 lib/Kconfig.debug | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index fb4889a..cf9cf82 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -930,7 +930,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC
+	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC && !SCORE
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -1408,7 +1408,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC
+	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC && !SCORE
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
-- 
1.9.2.459.g68773ac
