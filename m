Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab3CVPTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:19:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38650 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3CVPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:19:04 -0400
Date: Fri, 22 Mar 2013 20:48:38 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: oleg@redhat.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v2 3/4] uprobes/powerpc: teach uprobes to ignore gdb
	breakpoints
Message-ID: <20130322151838.GD20010@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130322151627.GB20010@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322151627.GB20010@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032215-3620-0000-0000-000001BC2DD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Powerpc has many trap variants that could be used by entities like gdb.
Currently, running gdb on a program being traced by uprobes causes an
endless loop since uprobes doesn't understand that the trap was inserted
by some other entity and a SIGTRAP needs to be delivered.

Teach uprobes to ignore breakpoints that do not belong to it.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/powerpc/kernel/uprobes.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-3.9-rc3/arch/powerpc/kernel/uprobes.c
===================================================================
--- linux-3.9-rc3.orig/arch/powerpc/kernel/uprobes.c
+++ linux-3.9-rc3/arch/powerpc/kernel/uprobes.c
@@ -31,6 +31,16 @@
 #define UPROBE_TRAP_NR	UINT_MAX
 
 /**
+ * is_trap_insn - check if the instruction is a trap variant
+ * @insn: instruction to be checked.
+ * Returns true if @insn is a trap variant.
+ */
+bool is_trap_insn(uprobe_opcode_t *insn)
+{
+	return (is_trap(*insn));
+}
+
+/**
  * arch_uprobe_analyze_insn
  * @mm: the probed address space.
  * @arch_uprobe: the probepoint information.

