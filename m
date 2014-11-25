Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaKYKrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:47:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaKYKnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 246/254] kgdb: Remove "weak" from kgdb_arch_pc() declaration
Date: Tue, 25 Nov 2014 10:39:56 +0000
Message-Id: <1416912004-5928-247-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/kgdb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6b06d378f3df..e465bb15912d 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -283,7 +283,7 @@ struct kgdb_io {
 
 extern struct kgdb_arch		arch_kgdb_ops;
 
-extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
+extern unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs);
 
 #ifdef CONFIG_SERIAL_KGDB_NMI
 extern int kgdb_register_nmi_console(void);
-- 
2.1.0

