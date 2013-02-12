Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324Ab3BLO6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:58:40 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:43588 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760056Ab3BLOxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:07 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 04/10] cris/kgdb: Use #ifdef PROCESS_SUPPORT where needed
Date: Tue, 12 Feb 2013 15:52:51 +0100
Message-Id: <1360680777-12622-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/arch-v10/kernel/kgdb.c:354:12: warning: 'current_thread_c' defined but not used [-Wunused-variable]
arch/cris/arch-v10/kernel/kgdb.c:355:12: warning: 'current_thread_g' defined but not used [-Wunused-variable]
arch/cris/arch-v10/kernel/kgdb.c:359:18: warning: 'reg_g' defined but not used [-Wunused-variable]
arch/cris/arch-v10/kernel/kgdb.c:622:1: warning: 'copy_registers' defined but not used [-Wunused-function]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 3c852b3..e02d2df 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -345,6 +345,7 @@ static int consistency_status = SUCCESS;
    in order to provide access mainly for 'g', 'G' and 'P'.
 */
 
+#ifdef PROCESS_SUPPORT
 /* Need two task id pointers in order to handle Hct and Hgt commands. */
 static int current_thread_c = 0;
 static int current_thread_g = 0;
@@ -352,6 +353,7 @@ static int current_thread_g = 0;
 /* Need two register images in order to handle Hct and Hgt commands. The
    variable reg_g is in addition to reg above. */
 static registers reg_g;
+#endif /* PROCESS_SUPPORT */
 
 /********************************** Breakpoint *******************************/
 /* Use an internal stack in the breakpoint and interrupt response routines */
@@ -610,6 +612,7 @@ putDebugString (const unsigned char *str, int length)
 }
 
 /********************************* Register image ****************************/
+#ifdef PROCESS_SUPPORT
 /* Copy the content of a register image into another. The size n is
    the size of the register image. Due to struct assignment generation of
    memcpy in libc. */
@@ -623,7 +626,6 @@ copy_registers (registers *dptr, registers *sptr, int n)
 		*dreg++ = *sreg++;
 }
 
-#ifdef PROCESS_SUPPORT
 /* Copy the stored registers from the stack. Put the register contents
    of thread thread_id in the struct reg. */
 static void
-- 
1.7.0.4

