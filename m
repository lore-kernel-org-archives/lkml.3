Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaETUZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:25:01 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:61393 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbaETUZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:25:00 -0400
Message-ID: <1400617498.4912.66.camel@x220>
Subject: [PATCH] powerpc: fix typo 'CONFIG_PMAC'
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 22:24:58 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 20:24:58.0700 (UTC) FILETIME=[920198C0:01CF7469]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling
perf_event_do_pending") added a check for CONFIG_PMAC were a check for
CONFIG_PPC_PMAC was clearly intended.

Fixes: b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling perf_event_do_pending")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Needs testing on 32 bit powermac, I guess.

This typo was introduced in v2.6.36. No one noticed because very few
people still use 32 bit powermacs?

 arch/powerpc/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 122a580f7322..bb3cfa10a4ea 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -551,7 +551,7 @@ void timer_interrupt(struct pt_regs * regs)
 	may_hard_irq_enable();
 

-#if defined(CONFIG_PPC32) && defined(CONFIG_PMAC)
+#if defined(CONFIG_PPC32) && defined(CONFIG_PPC_PMAC)
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 #endif
-- 
1.9.0

