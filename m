Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3LJU2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:28:11 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40223 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3LJU2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:28:09 -0500
Date: Tue, 10 Dec 2013 12:27:45 -0800
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [PATCH -next] x86, kaslr: clarify RANDOMIZE_BASE_MAX_OFFSET
Message-ID: <20131210202745.GA2961@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The help text for RANDOMIZE_BASE_MAX_OFFSET was confusing. This has been
clarified, and updated to be an export-only tunable.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a5c83b9dad45..e5fd1e67fd73 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1752,26 +1752,33 @@ config RANDOMIZE_BASE
 	   possible. At best, due to page table layouts, 64-bit can use
 	   9 bits of entropy and 32-bit uses 8 bits.
 
+	   If unsure, say N.
+
 config RANDOMIZE_BASE_MAX_OFFSET
-	hex "Maximum ASLR offset allowed"
+	hex "Maximum kASLR offset allowed" if EXPERT
 	depends on RANDOMIZE_BASE
 	range 0x0 0x20000000 if X86_32
 	default "0x20000000" if X86_32
 	range 0x0 0x40000000 if X86_64
 	default "0x40000000" if X86_64
 	---help---
-	 Determines the maximal offset in bytes that will be applied to the
-	 kernel when Address Space Layout Randomization (ASLR) is active.
-	 Must be less than or equal to the actual physical memory on the
-	 system. This must be a multiple of CONFIG_PHYSICAL_ALIGN.
+	  The lesser of RANDOMIZE_BASE_MAX_OFFSET and available physical
+	  memory is used to determine the maximal offset in bytes that will
+	  be applied to the kernel when kernel Address Space Layout
+	  Randomization (kASLR) is active. This must be a multiple of
+	  PHYSICAL_ALIGN.
+
+	  On 32-bit this is limited to 512MiB by page table layouts. The
+	  default is 512MiB.
 
-	 On 32-bit this is limited to 512MiB.
+	  On 64-bit this is limited by how the kernel fixmap page table is
+	  positioned, so this cannot be larger than 1GiB currently. Without
+	  RANDOMIZE_BASE, there is a 512MiB to 1.5GiB split between kernel
+	  and modules. When RANDOMIZE_BASE_MAX_OFFSET is above 512MiB, the
+	  modules area will shrink to compensate, up to the current maximum
+	  1GiB to 1GiB split. The default is 1GiB.
 
-	 On 64-bit this is limited by how the kernel fixmap page table is
-	 positioned, so this cannot be larger that 1GiB currently. Normally
-	 there is a 512MiB to 1.5GiB split between kernel and modules. When
-	 this is raised above the 512MiB default, the modules area will
-	 shrink to compensate, up to the current maximum 1GiB to 1GiB split.
+	  If unsure, leave at the default value.
 
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
