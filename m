Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3HEWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:16:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:21609 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab3HEWQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:16:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="376604381"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, wim@iguana.be
Subject: [PATCH] lto, watchdog/hpwdt.c: Make assembler label global
Date: Mon,  5 Aug 2013 15:16:39 -0700
Message-Id: <1375740999-8097-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

We cannot assume that the inline assembler code always ends up
in the same file as the original C file. So make any assembler labels
that are called with "extern" by C global

Cc: wim@iguana.be
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/watchdog/hpwdt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index de7e4f4..5be5e3d 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -162,7 +162,8 @@ extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
 #define HPWDT_ARCH	32
 
 asm(".text                          \n\t"
-    ".align 4                       \n"
+    ".align 4                       \n\t"
+    ".globl asminline_call	    \n"
     "asminline_call:                \n\t"
     "pushl       %ebp               \n\t"
     "movl        %esp, %ebp         \n\t"
@@ -352,7 +353,8 @@ static int detect_cru_service(void)
 #define HPWDT_ARCH	64
 
 asm(".text                      \n\t"
-    ".align 4                   \n"
+    ".align 4                   \n\t"
+    ".globl asminline_call	\n"
     "asminline_call:            \n\t"
     "pushq      %rbp            \n\t"
     "movq       %rsp, %rbp      \n\t"
-- 
1.8.3.1

