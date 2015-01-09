Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbbAILRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:17:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbbAILRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:17:22 -0500
From: Michal Marek <mmarek@suse.cz>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH] x86: Fix make clean
Date: Fri,  9 Jan 2015 12:17:15 +0100
Message-Id: <1420802235-8707-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The $(targets) variable should not depend on the configuration, so that
make clean always cleans every possible generated file. Where this is
impractical, list the potential products of a build in $(clean-files).

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/x86/boot/Makefile       | 2 +-
 arch/x86/kernel/cpu/Makefile | 2 +-
 arch/x86/vdso/Makefile       | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 5b016e2..b93cc4d 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -47,10 +47,10 @@ $(obj)/cpu.o: $(obj)/cpustr.h
 
 quiet_cmd_cpustr = CPUSTR  $@
       cmd_cpustr = $(obj)/mkcpustr > $@
-targets += cpustr.h
 $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 	$(call if_changed,cpustr)
 endif
+targets += cpustr.h
 
 # ---------------------------------------------------------------------------
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index e27b49d..6e864cf 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -62,7 +62,7 @@ quiet_cmd_mkcapflags = MKCAP   $@
 
 cpufeature = $(src)/../../include/asm/cpufeature.h
 
-targets += capflags.c
 $(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
 	$(call if_changed,mkcapflags)
 endif
+targets += capflags.c
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 5a4affe..f971e20 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -205,4 +205,5 @@ $(vdso_img_insttargets): install_%: $(obj)/%.dbg $(MODLIB)/vdso FORCE
 PHONY += vdso_install $(vdso_img_insttargets)
 vdso_install: $(vdso_img_insttargets) FORCE
 
-clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
+clean-files := vdso-image-* vdso32-syscall* vdso32-sysenter* vdso32-int80* \
+               *.so *.so.dbg
-- 
1.9.2

