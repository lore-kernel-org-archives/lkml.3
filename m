Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab3CVPSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:18:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58600 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933169Ab3CVPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:18:18 -0400
Date: Fri, 22 Mar 2013 20:47:58 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: oleg@redhat.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, ppcdev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v2 2/4] uprobes: refuse uprobe on trap variants
Message-ID: <20130322151758.GC20010@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20130322151627.GB20010@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322151627.GB20010@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032215-3620-0000-0000-000001BC2C55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Refuse to place a uprobe if a trap variant already exists in the
file copy at the address.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.9-rc3/kernel/events/uprobes.c
===================================================================
--- linux-3.9-rc3.orig/kernel/events/uprobes.c
+++ linux-3.9-rc3/kernel/events/uprobes.c
@@ -573,7 +573,7 @@ static int prepare_uprobe(struct uprobe
 		goto out;
 
 	ret = -ENOTSUPP;
-	if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
+	if (is_trap_insn((uprobe_opcode_t *)uprobe->arch.insn))
 		goto out;
 
 	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);

