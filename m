Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161472Ab3FUIFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:05:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42251 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161196Ab3FUIFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:05:03 -0400
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86/platform: Add kvmconfig to the phony targets
Date: Fri, 21 Jun 2013 10:04:51 +0200
Message-Id: <1371801891-23618-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <tip-46ff53874bd935ab9955dee56d60212857e89bf3@git.kernel.org>
References: <tip-46ff53874bd935ab9955dee56d60212857e89bf3@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... so as not to disable it with a file of the same name in the toplevel
build directory.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 91ee171f1cff..07639c656fcd 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -220,6 +220,7 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
+PHONY += kvmconfig
 kvmconfig:
 	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config arch/x86/configs/kvm_guest.config
-- 
1.8.3

