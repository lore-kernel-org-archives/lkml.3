Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaLCLwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:52:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbaLCL1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 058/101] kgdb: Remove "weak" from kgdb_arch_pc() declaration
Date: Wed,  3 Dec 2014 12:26:20 +0100
Message-Id: <33176fe6d29e0a689928532db6cf44de67c72921.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 107bcc6d566cb40184068d888637f9aefe6252dd upstream.

kernel/debug/debug_core.c provides a default kgdb_arch_pc() definition
explicitly marked "weak".  Several architectures provide their own
definitions intended to override the default, but the "weak" attribute on
the declaration applied to the arch definitions as well, so the linker
chose one based on link order (see 10629d711ed7 ("PCI: Remove __weak
annotation from pcibios_get_phb_of_node decl")).

Remove the "weak" attribute from the declaration so we always prefer a
non-weak definition over the weak one, independent of link order.

Fixes: 688b744d8bc8 ("kgdb: fix signedness mixmatches, add statics, add declaration to header")
Tested-by: Vineet Gupta <vgupta@synopsys.com>	# for ARC build
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/kgdb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index c6e091bf39a5..bdfc95bddde9 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -283,7 +283,7 @@ struct kgdb_io {
 
 extern struct kgdb_arch		arch_kgdb_ops;
 
-extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
+extern unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs);
 
 #ifdef CONFIG_SERIAL_KGDB_NMI
 extern int kgdb_register_nmi_console(void);
-- 
2.1.3

