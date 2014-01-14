Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaANSs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:48:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaANSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:48:52 -0500
Date: Tue, 14 Jan 2014 10:48:40 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-da2b6fb990cf782b18952f534ec7323453bc4fc9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20131210202745.GA2961@www.outflux.net>
References: <20131210202745.GA2961@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr: Clarify RANDOMIZE_BASE_MAX_OFFSET
Git-Commit-ID: da2b6fb990cf782b18952f534ec7323453bc4fc9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 10:48:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da2b6fb990cf782b18952f534ec7323453bc4fc9
Gitweb:     http://git.kernel.org/tip/da2b6fb990cf782b18952f534ec7323453bc4fc9
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue, 10 Dec 2013 12:27:45 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 14 Jan 2014 10:45:56 -0800

x86, kaslr: Clarify RANDOMIZE_BASE_MAX_OFFSET

The help text for RANDOMIZE_BASE_MAX_OFFSET was confusing. This has been
clarified, and updated to be an export-only tunable.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20131210202745.GA2961@www.outflux.net
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 596cd9e..5c9e19d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1747,26 +1747,33 @@ config RANDOMIZE_BASE
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
