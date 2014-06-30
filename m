Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaF3ECV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 00:02:21 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48462 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaF3ECT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 00:02:19 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixes return issues in uic_init_one
Date: Mon, 30 Jun 2014 00:02:14 -0400
Message-Id: <1404100934-7490-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the FIXME messages for returning a ENOMEM error
if uic is not allocated and if uic->irqhost is not allocated a
IRQ domain that is linear returns EIO.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/powerpc/sysdev/uic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 9203393..f95010a 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -239,7 +239,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 
 	uic = kzalloc(sizeof(*uic), GFP_KERNEL);
 	if (! uic)
-		return NULL; /* FIXME: panic? */
+		return -ENOMEM; 
 
 	raw_spin_lock_init(&uic->lock);
 	indexp = of_get_property(node, "cell-index", &len);
@@ -261,7 +261,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 	uic->irqhost = irq_domain_add_linear(node, NR_UIC_INTS, &uic_host_ops,
 					     uic);
 	if (! uic->irqhost)
-		return NULL; /* FIXME: panic? */
+		return -EIO; 
 
 	/* Start with all interrupts disabled, level and non-critical */
 	mtdcr(uic->dcrbase + UIC_ER, 0);
-- 
1.9.1

