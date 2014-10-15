Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaJORGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:43 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:59415 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJORGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:39 -0400
Subject: [PATCH v1 08/10] kgdb: Remove "weak" from kgdb_arch_pc() declaration
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:06:37 -0600
Message-ID: <20141015170637.4063.22185.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/debug/debug_core.c provides a default kgdb_arch_pc() definition
explicitly marked "weak".  Several architectures provide their own
definitions intended to override the default, but the "weak" attribute on
the declaration applied to the arch definitions as well, so the linker
chose one based on link order (see 10629d711ed7 ("PCI: Remove __weak
annotation from pcibios_get_phb_of_node decl")).

Remove the "weak" attribute from the declaration so we always prefer a
non-weak definition over the weak one, independent of link order.

Fixes: 688b744d8bc8 ("kgdb: fix signedness mixmatches, add statics, add declaration to header")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kgdb.h |    2 +-
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

