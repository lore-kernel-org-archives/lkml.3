Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3CVPUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:20:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42117 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3CVPUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:20:05 -0400
Date: Fri, 22 Mar 2013 20:49:46 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: oleg@redhat.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v2 4/4] uprobes/powerpc: remove additional trap instruction
	check
Message-ID: <20130322151946.GE20010@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130322151627.GB20010@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322151627.GB20010@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032215-7182-0000-0000-000005E93A2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

prepare_uprobe() already checks if the underlying unstruction
(on file) is a trap variant. We don't need to check this again.

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
 

