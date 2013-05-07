Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3EGJw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:52:57 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40813 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab3EGJw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:52:56 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] h8300: Fix <asm/tlb.h>
Date: Tue,  7 May 2013 11:52:52 +0200
Message-Id: <1367920372-18429-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ten years ago, a mismerge happened, concatenating two slightly different
versions of the same file. As a consequence, <asm-generic/tlb.h> was never
included, leading to a build failure only now:

kernel/cpu/idle.c: In function 'cpu_idle_loop':
kernel/cpu/idle.c:70:4: error: implicit declaration of function 'check_pgt_cache' [-Werror=implicit-function-declaration]

Remove the duplicates, and the header comment with the no longer correct
file name.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/include/asm/tlb.h |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/h8300/include/asm/tlb.h b/arch/h8300/include/asm/tlb.h
index 3dea80a..7f07430 100644
--- a/arch/h8300/include/asm/tlb.h
+++ b/arch/h8300/include/asm/tlb.h
@@ -1,16 +1,3 @@
-/* 
-  include/asm-h8300/tlb.h 
-*/
-
-#ifndef __H8300_TLB_H__
-#define __H8300_TLB_H__
-
-#define tlb_flush(tlb)	do { } while(0)
-
-/* 
-  include/asm-h8300/tlb.h 
-*/
-
 #ifndef __H8300_TLB_H__
 #define __H8300_TLB_H__
 
@@ -19,5 +6,3 @@
 #include <asm-generic/tlb.h>
 
 #endif
-
-#endif
-- 
1.7.0.4

