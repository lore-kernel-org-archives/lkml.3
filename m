Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322AbaGXKSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:18:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54774 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbaGXJr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 041/128] powerpc: fix typo 'CONFIG_PMAC'
Date: Thu, 24 Jul 2014 10:44:50 +0100
Message-Id: <1406195177-8656-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 6e0fdf9af216887e0032c19d276889aad41cad00 upstream.

Commit b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling
perf_event_do_pending") added a check for CONFIG_PMAC were a check for
CONFIG_PPC_PMAC was clearly intended.

Fixes: b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling perf_event_do_pending")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index d1f90d3d6f07..93ce00413e25 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -512,7 +512,7 @@ void timer_interrupt(struct pt_regs * regs)
 
 	__get_cpu_var(irq_stat).timer_irqs++;
 
-#if defined(CONFIG_PPC32) && defined(CONFIG_PMAC)
+#if defined(CONFIG_PPC32) && defined(CONFIG_PPC_PMAC)
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 #endif
-- 
1.9.1

