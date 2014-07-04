Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031691AbaGDWjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:39:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031280AbaGDWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 41/59] powerpc: fix typo CONFIG_PMAC
Date: Fri,  4 Jul 2014 15:19:30 -0700
Message-Id: <20140704221541.509256013@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
References: <20140704221539.544876024@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 6e0fdf9af216887e0032c19d276889aad41cad00 upstream.

Commit b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling
perf_event_do_pending") added a check for CONFIG_PMAC were a check for
CONFIG_PPC_PMAC was clearly intended.

Fixes: b0d278b7d3ae ("powerpc/perf_event: Reduce latency of calling perf_event_do_pending")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -511,7 +511,7 @@ void timer_interrupt(struct pt_regs * re
 	may_hard_irq_enable();
 
 
-#if defined(CONFIG_PPC32) && defined(CONFIG_PMAC)
+#if defined(CONFIG_PPC32) && defined(CONFIG_PPC_PMAC)
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 #endif


