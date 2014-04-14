Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaDNHXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:23:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaDNHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:23:05 -0400
Date: Mon, 14 Apr 2014 00:22:30 -0700
From: tip-bot for Antonio Borneo <tipbot@zytor.com>
Message-ID: <tip-f96364041ccda63ff4bed96fd06b267d8d841dc0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        penberg@kernel.org, borneo.antonio@gmail.com, tglx@linutronix.de,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        borneo.antonio@gmail.com, penberg@kernel.org, tglx@linutronix.de,
        bp@suse.de
In-Reply-To: <1397377568-8375-1-git-send-email-borneo.antonio@gmail.com>
References: <1397377568-8375-1-git-send-email-borneo.antonio@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/platform: Fix "make O=dir kvmconfig"
Git-Commit-ID: f96364041ccda63ff4bed96fd06b267d8d841dc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f96364041ccda63ff4bed96fd06b267d8d841dc0
Gitweb:     http://git.kernel.org/tip/f96364041ccda63ff4bed96fd06b267d8d841dc0
Author:     Antonio Borneo <borneo.antonio@gmail.com>
AuthorDate: Sun, 13 Apr 2014 16:26:08 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 Apr 2014 08:50:36 +0200

x86/platform: Fix "make O=dir kvmconfig"

Running:

	make O=dir x86_64_defconfig
	make O=dir kvmconfig

the second command dirties the source tree with file ".config",
symlink "source" and objects in folder "scripts".

Fixed by using properly prefixed paths in the arch Makefile.

Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1397377568-8375-1-git-send-email-borneo.antonio@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3b9348a..0db8910 100644
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
