Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3FGXIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:08:10 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:48255 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab3FGXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:53 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 21/31] mips/kvm: Allow set_except_vector() to be used from MIPSVZ code.
Date: Fri,  7 Jun 2013 16:03:25 -0700
Message-Id: <1370646215-6543-22-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We need to move it out of __init so we don't have section mismatch problems.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/uasm.h | 2 +-
 arch/mips/kernel/traps.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/uasm.h b/arch/mips/include/asm/uasm.h
index 370d967..90b4f5e 100644
--- a/arch/mips/include/asm/uasm.h
+++ b/arch/mips/include/asm/uasm.h
@@ -11,7 +11,7 @@
 
 #include <linux/types.h>
 
-#ifdef CONFIG_EXPORT_UASM
+#if defined(CONFIG_EXPORT_UASM) || IS_ENABLED(CONFIG_KVM_MIPSVZ)
 #include <linux/export.h>
 #define __uasminit
 #define __uasminitdata
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index f008795..fca0a2f 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1457,7 +1457,7 @@ unsigned long ebase;
 unsigned long exception_handlers[32];
 unsigned long vi_handlers[64];
 
-void __init *set_except_vector(int n, void *addr)
+void __uasminit *set_except_vector(int n, void *addr)
 {
 	unsigned long handler = (unsigned long) addr;
 	unsigned long old_handler;
-- 
1.7.11.7

