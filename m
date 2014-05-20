Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaETT7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:59:45 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:52360 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbaETT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:59:44 -0400
Message-ID: <1400615982.4912.62.camel@x220>
Subject: [PATCH] powerpc: fix typo 'CONFIG_PPC_CPU'
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 21:59:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 19:59:43.0537 (UTC) FILETIME=[0AE61210:01CF7466]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cd64d1697cf0 ("powerpc: mtmsrd not defined") added a check for
CONFIG_PPC_CPU were a check for CONFIG_PPC_FPU was clearly intended.

Fixes: cd64d1697cf0 ("powerpc: mtmsrd not defined")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested. This typo was introduced in v2.6.37. Did no one
notice? Anyhow, this really needs some testing.

 arch/powerpc/lib/sstep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index c0511c27a733..412dd46dd0b7 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1470,7 +1470,7 @@ int __kprobes emulate_step(struct pt_regs *regs, unsigned int instr)
 				regs->gpr[rd] = byterev_4(val);
 			goto ldst_done;
 
-#ifdef CONFIG_PPC_CPU
+#ifdef CONFIG_PPC_FPU
 		case 535:	/* lfsx */
 		case 567:	/* lfsux */
 			if (!(regs->msr & MSR_FP))
-- 
1.9.0

