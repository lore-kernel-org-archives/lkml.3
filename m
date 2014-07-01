Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaGACrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:47:42 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61022 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaGACrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:47:41 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Remove FIXME messages in arch/powerpc/sysdev/uic.c
Date: Mon, 30 Jun 2014 22:47:36 -0400
Message-Id: <1404182856-4945-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes FIXME messages in the function uic_init_one
as this FIXMEs are not valid due to the kernel being better
to panic due to boards without these allocated not being
able to service IRQs.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/powerpc/sysdev/uic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 9203393..937f6a5 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -239,7 +239,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 
 	uic = kzalloc(sizeof(*uic), GFP_KERNEL);
 	if (! uic)
-		return NULL; /* FIXME: panic? */
+		return NULL;
 
 	raw_spin_lock_init(&uic->lock);
 	indexp = of_get_property(node, "cell-index", &len);
@@ -261,7 +261,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 	uic->irqhost = irq_domain_add_linear(node, NR_UIC_INTS, &uic_host_ops,
 					     uic);
 	if (! uic->irqhost)
-		return NULL; /* FIXME: panic? */
+		return NULL;
 
 	/* Start with all interrupts disabled, level and non-critical */
 	mtdcr(uic->dcrbase + UIC_ER, 0);
-- 
1.9.1

