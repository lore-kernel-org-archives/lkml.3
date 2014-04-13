Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaDMI00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 04:26:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaDMI0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 04:26:23 -0400
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, Antonio Borneo <borneo.antonio@gmail.com>
Subject: [PATCH] x86/platform: fix "make O=dir kvmconfig"
Date: Sun, 13 Apr 2014 16:26:08 +0800
Message-Id: <1397377568-8375-1-git-send-email-borneo.antonio@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running:
	make O=dir x86_64_defconfig
	make O=dir kvmconfig
the second command dirties the source tree with file ".config",
symlink "source" and objects in folder "scripts".

Fixed by adding paths in arch Makefile.

Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
---
 arch/x86/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 602f57e..d1b7c37 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -250,8 +250,8 @@ archclean:
 PHONY += kvmconfig
 kvmconfig:
 	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config arch/x86/configs/kvm_guest.config
-	$(Q)yes "" | $(MAKE) oldconfig
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/kvm_guest.config
+	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
 
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
-- 
1.9.2

