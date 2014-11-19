Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaKSUzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:55:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392AbaKSUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 3.17 116/141] kgdb: Remove "weak" from kgdb_arch_pc() declaration
Date: Wed, 19 Nov 2014 12:52:19 -0800
Message-Id: <20141119205154.485806254@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kgdb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -283,7 +283,7 @@ struct kgdb_io {
 
 extern struct kgdb_arch		arch_kgdb_ops;
 
-extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
+extern unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs);
 
 #ifdef CONFIG_SERIAL_KGDB_NMI
 extern int kgdb_register_nmi_console(void);


