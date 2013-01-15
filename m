Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3AOKbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:31:15 -0500
Received: from mail1.windriver.com ([147.11.146.13]:49338 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3AOKbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:31:12 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC][v0][PATCH 1/1] ppc64: ignore interrupts while offline
Date: Tue, 15 Jan 2013 18:31:00 +0800
Message-ID: <1358245860-6546-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With lazy interrupt, some implementations of hotplug will
get some interrupts even while offline, just ignore these.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/irq.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 4f97fe3..dbca574 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -144,6 +144,12 @@ notrace unsigned int __check_irq_replay(void)
 	 */
 	unsigned char happened = local_paca->irq_happened;
 
+	/* Some implementations of hotplug will get some interrupts while
+	 * offline, just ignore these.
+	 */
+	if (cpu_is_offline(smp_processor_id()))
+		return 0;
+
 	/* Clear bit 0 which we wouldn't clear otherwise */
 	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
 
-- 
1.7.9.5

