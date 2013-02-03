Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3BCPUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:20:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934Ab3BCOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:26 -0500
Message-Id: <20130203144647.169118181@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Thomas Schwinge <thomas@codesourcery.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [ 035/128] sh: Fix FDPIC binary loader
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Schwinge <thomas@codesourcery.com>

commit 4a71997a3279a339e7336ea5d0cd27282e2dea44 upstream.

Ensure that the aux table is properly initialized, even when optional features
are missing.  Without this, the FDPIC loader did not work.  This was meant to
be included in commit d5ab780305bb6d60a7b5a74f18cf84eb6ad153b1.

Signed-off-by: Thomas Schwinge <thomas@codesourcery.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sh/include/asm/elf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/elf.h b/arch/sh/include/asm/elf.h
index 37924af..bf9f44f 100644
--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -203,9 +203,9 @@ extern void __kernel_vsyscall;
 	if (vdso_enabled)					\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE);	\
 	else							\
-		NEW_AUX_ENT(AT_IGNORE, 0);
+		NEW_AUX_ENT(AT_IGNORE, 0)
 #else
-#define VSYSCALL_AUX_ENT
+#define VSYSCALL_AUX_ENT	NEW_AUX_ENT(AT_IGNORE, 0)
 #endif /* CONFIG_VSYSCALL */
 
 #ifdef CONFIG_SH_FPU


