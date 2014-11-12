Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbaKLBfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:35:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaKLBfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:35:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.17 304/319] irqchip: armada-370-xp: Fix MSI interrupt handling
Date: Wed, 12 Nov 2014 10:17:22 +0900
Message-Id: <20141112011043.163427376@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Jaszczyk <jaz@semihalf.com>

commit 298dcb2dd0267d51e4f7c94a628cd0765a50ad75 upstream.

The MSI interrupts use the 16 high doorbells, which are notified by using IRQ1
of the main interrupt controller.

The MSI interrupts were handled correctly for Armada-XP and Armada-370 but not
for Armada-375 and Armada-38x, which use chained handler for the MPIC.

This commit fixes that by checking proper interrupt number in chained handler
for the MPIC.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Fixes: bc69b8adfe22 ("irqchip: armada-370-xp: Setup a chained handler for the MPIC")
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Link: https://lkml.kernel.org/r/1411643839-64925-2-git-send-email-jaz@semihalf.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-armada-370-xp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -417,9 +417,9 @@ static void armada_370_xp_mpic_handle_ca
 
 	irqmap = readl_relaxed(per_cpu_int_base + ARMADA_375_PPI_CAUSE);
 
-	if (irqmap & BIT(0)) {
+	if (irqmap & BIT(1)) {
 		armada_370_xp_handle_msi_irq(NULL, true);
-		irqmap &= ~BIT(0);
+		irqmap &= ~BIT(1);
 	}
 
 	for_each_set_bit(irqn, &irqmap, BITS_PER_LONG) {


