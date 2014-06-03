Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaFCNN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:13:57 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44322 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaFCNN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:13:56 -0400
Date: Tue, 3 Jun 2014 15:13:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build changes for v3.16
Message-ID: <20140603131350.GA27714@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   # HEAD: a9358bc3531901a15e2f7cd48550c9555fc0288f x86/build: Supress realmode.bin is up to date message

Two small build related cleanups.


  out-of-topic modifications in x86-build-for-linus:
  ----------------------------------------------------
  include/linux/compiler-intel.h     # 73679e5: compiler-intel.h: Remove duplicat

 Thanks,

	Ingo

------------------>
Peter Foley (1):
      x86/build: Supress realmode.bin is up to date message

Pranith Kumar (1):
      compiler-intel.h: Remove duplicate definition


 arch/x86/realmode/rm/Makefile  | 3 ++-
 include/linux/compiler-intel.h | 3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 3497f14..7c0d7be 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -52,8 +52,9 @@ $(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
 OBJCOPYFLAGS_realmode.bin := -O binary
 
 targets += realmode.bin
-$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
+$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs FORCE
 	$(call if_changed,objcopy)
+	@:
 
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index 5529c52..ba147a1 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -13,12 +13,9 @@
 /* Intel ECC compiler doesn't support gcc specific asm stmts.
  * It uses intrinsics to do the equivalent things.
  */
-#undef barrier
 #undef RELOC_HIDE
 #undef OPTIMIZER_HIDE_VAR
 
-#define barrier() __memory_barrier()
-
 #define RELOC_HIDE(ptr, off)					\
   ({ unsigned long __ptr;					\
      __ptr = (unsigned long) (ptr);				\
