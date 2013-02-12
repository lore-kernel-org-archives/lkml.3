Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311Ab3BLO4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:56:50 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:57185 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760709Ab3BLOxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 06/10] cris/kgdb: Remove obsolete USED*() macros
Date: Tue, 12 Feb 2013 15:52:53 +0100
Message-Id: <1360680777-12622-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_exception and internal_stack are now global

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 7e24b73..d0b6257 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -260,10 +260,6 @@ extern unsigned char executing_task;
 /* The number of characters used for a 64 bit thread identifier. */
 #define HEXCHARS_IN_THREAD_ID 16
 
-/* Avoid warning as the internal_stack is not used in the C-code. */
-#define USEDVAR(name)    { if (name) { ; } }
-#define USEDFUN(name) { void (*pf)(void) = (void *)name; USEDVAR(pf) }
-
 /********************************** Packet I/O ******************************/
 /* BUFMAX defines the maximum number of characters in
    inbound/outbound buffers */
@@ -854,11 +850,6 @@ kill_restart (void)
 void
 handle_exception (int sigval)
 {
-	/* Avoid warning of not used. */
-
-	USEDFUN(handle_exception);
-	USEDVAR(internal_stack[0]);
-
 	/* Send response. */
 
 	stub_is_stopped (sigval);
-- 
1.7.0.4

