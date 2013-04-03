Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab3DCNRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:17:06 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56552 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760268Ab3DCNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:17:05 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2013 09:17:05 EDT
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        Philip Kranz <philip.kranz@googlemail.com>
Subject: [PATCH] Add non-zero module sections to sysfs
Date: Wed,  3 Apr 2013 15:08:19 +0200
Message-Id: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add non-zero module sections to sysfs on architectures unequal to PARISC.
KGDB needs all module sections for proper module debugging. Therefore, commit 
35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
architecture.

Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Signed-off-by: Philip Kranz <philip.kranz@googlemail.com>

---
 kernel/module.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 3c2c72d..5393a54 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1316,7 +1316,11 @@ resolve_symbol_wait(struct module *mod,
 #ifdef CONFIG_KALLSYMS
 static inline bool sect_empty(const Elf_Shdr *sect)
 {
+#if defined(CONFIG_PARISC)
 	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
+#else
+	return !(sect->sh_flags & SHF_ALLOC);
+#endif
 }
 
 struct module_sect_attr
-- 
1.7.10.4

