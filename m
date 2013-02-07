Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3BGIEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:04:33 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:31191
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab3BGIEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:04:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH] mpic: fix Destination Registers init problem
Date: Thu, 7 Feb 2013 16:07:00 +0800
Message-ID: <1360224420-5009-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Freescale implementation of the MPIC only allows a single CPU
destination for non-IPI interrupts. Test the flag MPIC_SINGLE_DEST_CPU
to check if the Destination registers should be set.

This prevents more than one bit is set at secondary processors
initilizing time if the flag MPIC_SINGLE_DEST_CPU is set.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 arch/powerpc/sysdev/mpic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 9c6e535..cc537f8 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1675,7 +1675,7 @@ void mpic_setup_this_cpu(void)
 	 * it differently, then we should make sure we also change the default
 	 * values of irq_desc[].affinity in irq.c.
  	 */
-	if (distribute_irqs) {
+	if (distribute_irqs && !(mpic->flags & MPIC_SINGLE_DEST_CPU)) {
 	 	for (i = 0; i < mpic->num_sources ; i++)
 			mpic_irq_write(i, MPIC_INFO(IRQ_DESTINATION),
 				mpic_irq_read(i, MPIC_INFO(IRQ_DESTINATION)) | msk);
-- 
1.7.1


