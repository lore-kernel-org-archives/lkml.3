Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3CUMl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:41:28 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:55680 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab3CUMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:41:26 -0400
Message-ID: <1363869683.1390.134.camel@x61.thuisdomein>
Subject: [PATCH] cpuidle: remove ARCH_HAS_DEFAULT_IDLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <len.brown@intel.com>, x86@kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 13:41:23 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 12:41:24.0034 (UTC) FILETIME=[659CA220:01CE2631]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARCH_HAS_DEFAULT_IDLE is unused. Commit
a0bfa1373859e9d11dc92561a8667588803e42d8 ("cpuidle: stop depending on
pm_idle") removed the only place were it was actually used. But
it did not remove its Kconfig entries (for sh and x86). Remove those two
entries now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Sent as a single patch. I'm happy to split it into two and resend it
if needed.

 arch/sh/Kconfig  | 3 ---
 arch/x86/Kconfig | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5e85963..6d4327f 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -148,9 +148,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config ARCH_HAS_DEFAULT_IDLE
-	def_bool y
-
 config NO_IOPORT
 	def_bool !PCI
 	depends on !SH_CAYMAN && !SH_SH4202_MICRODEV && !SH_SHMIN && \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..fcf2939 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -188,9 +188,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
-config ARCH_HAS_DEFAULT_IDLE
-	def_bool y
-
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
-- 
1.7.11.7

