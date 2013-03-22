Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab3CVLqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:46:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48111 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab3CVLqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:46:33 -0400
Date: Fri, 22 Mar 2013 17:16:24 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: oleg@redhat.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 3/3] uprobes/powerpc: ignore trap variants during register
Message-ID: <20130322114624.GI26183@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130322114446.GG26183@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322114446.GG26183@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032211-4834-0000-0000-000004F88206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

The current implementation of uprobes assumes that uprobes always wins
even when a register request is at a location with a conditional
breakpoint by some other entity. Refer to [1] for more details.

Remove the breakpoint instruction check during registration on powerpc,
so that uprobes behavior on powerpc matches that of x86.

[1] https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-March/104771.html

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/powerpc/kernel/uprobes.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-3.9-rc3/arch/powerpc/kernel/uprobes.c
===================================================================
--- linux-3.9-rc3.orig/arch/powerpc/kernel/uprobes.c
+++ linux-3.9-rc3/arch/powerpc/kernel/uprobes.c
@@ -53,12 +53,6 @@ int arch_uprobe_analyze_insn(struct arch
 	if (addr & 0x03)
 		return -EINVAL;
 
-	/*
-	 * We currently don't support a uprobe on an already
-	 * existing breakpoint instruction underneath
-	 */
-	if (is_trap(auprobe->ainsn))
-		return -ENOTSUPP;
 	return 0;
 }
 

