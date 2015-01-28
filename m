Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbbA1U5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:57:38 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42001 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbbA1U5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:57:36 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: [PATCH] x86/vdso: teach 'make clean' remove vdso64 binaries
Date: Wed, 28 Jan 2015 17:04:27 +0300
Message-Id: <1422453867-17326-1-git-send-email-andrej.skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 'make clean' vdso64.so and vdso64.dbg.so were left in arch/x86/vdso/.

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
---
 arch/x86/vdso/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 5a4affe..09297c8 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -205,4 +205,4 @@ $(vdso_img_insttargets): install_%: $(obj)/%.dbg $(MODLIB)/vdso FORCE
 PHONY += vdso_install $(vdso_img_insttargets)
 vdso_install: $(vdso_img_insttargets) FORCE
 
-clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
+clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80* vdso64*
-- 
1.7.10.4

