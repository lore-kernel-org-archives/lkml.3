Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaBDUQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:16:07 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:47190 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaBDUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:16:03 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] m68k: Switch to asm-generic/barrier.h
Date: Tue,  4 Feb 2014 21:15:53 +0100
Message-Id: <1391544954-7422-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391544954-7422-1-git-send-email-geert@linux-m68k.org>
References: <1391544954-7422-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic nop() implementation is fine for m68k.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/Kbuild    |    1 +
 arch/m68k/include/asm/barrier.h |    8 --------
 2 files changed, 1 insertion(+), 8 deletions(-)
 delete mode 100644 arch/m68k/include/asm/barrier.h

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index df4d46fc321b..6fb9e813a910 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -1,3 +1,4 @@
+generic-y += barrier.h
 generic-y += bitsperlong.h
 generic-y += clkdev.h
 generic-y += cputime.h
diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
deleted file mode 100644
index 15c5f77c1614..000000000000
--- a/arch/m68k/include/asm/barrier.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _M68K_BARRIER_H
-#define _M68K_BARRIER_H
-
-#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
-
-#include <asm-generic/barrier.h>
-
-#endif /* _M68K_BARRIER_H */
-- 
1.7.9.5

