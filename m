Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaAZUNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:13:24 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54331 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaAZUNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:13:23 -0500
From: Zhihui Zhang <zzhsuny@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Use LOAD_PHYSICAL_ADDR in vmlinux.lds.S
Date: Sun, 26 Jan 2014 15:13:14 -0500
Message-Id: <1390767194-28654-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This unifies the way to specify start VMA on both 32 and 64-bit platforms.
I would like to remove __PHYSICAL_START as well, but that appears to be harder.

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 arch/x86/kernel/vmlinux.lds.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index da6b35a..e81bf49 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -81,11 +81,10 @@ PHDRS {
 
 SECTIONS
 {
-#ifdef CONFIG_X86_32
         . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+#ifdef CONFIG_X86_32
         phys_startup_32 = startup_32 - LOAD_OFFSET;
 #else
-        . = __START_KERNEL;
         phys_startup_64 = startup_64 - LOAD_OFFSET;
 #endif
 
-- 
1.8.1.2

