Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaCJBDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:03:18 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51081 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaCJBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:03:16 -0400
X-Originating-IP: 50.43.32.211
Date: Sun, 9 Mar 2014 18:03:10 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] x86: Always define BUG() and HAVE_ARCH_BUG, even with
 !CONFIG_BUG
Message-ID: <0c48ec31fe236361884f49d559f895b3883846c2.1394412745.git.josh@joshtriplett.org>
References: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that BUG() always has a definition that causes a trap (via
an undefined instruction), and that the compiler still recognizes the
code following BUG() as unreachable, avoiding warnings that would
otherwise appear (such as on non-void functions that don't return a
value after BUG()).

In addition to saving a few bytes over the generic infinite-loop
implementation, this implementation traps rather than looping, which
potentially allows for better error-recovery behavior (such as by
rebooting).

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v3: New patch for x86-optimized implementation of a simple bug for
!CONFIG_BUG, based on Arnd Bergmann's proposal.

 arch/x86/include/asm/bug.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 2f03ff0..ba38ebb 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_BUG_H
 #define _ASM_X86_BUG_H
 
-#ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
@@ -33,8 +32,6 @@ do {								\
 } while (0)
 #endif
 
-#endif /* !CONFIG_BUG */
-
 #include <asm-generic/bug.h>
 
 #endif /* _ASM_X86_BUG_H */
-- 
1.9.0

