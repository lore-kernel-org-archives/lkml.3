Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbbAARwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:52:14 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52948 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbAARwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:52:12 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-rpc: ecard:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:55:12 +0100
Message-Id: <1420134912-1742-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
ecard_disablefiq() ecard_enablefiq()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-rpc/ecard.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/arm/mach-rpc/ecard.c b/arch/arm/mach-rpc/ecard.c
index fcb1d59..e5c8caf 100644
--- a/arch/arm/mach-rpc/ecard.c
+++ b/arch/arm/mach-rpc/ecard.c
@@ -462,35 +462,6 @@ static struct irq_chip ecard_chip = {
 	.irq_unmask	= ecard_irq_unmask,
 };
 
-void ecard_enablefiq(unsigned int fiqnr)
-{
-	ecard_t *ec = slot_to_ecard(fiqnr);
-
-	if (ec) {
-		if (!ec->ops)
-			ec->ops = &ecard_default_ops;
-
-		if (ec->claimed && ec->ops->fiqenable)
-			ec->ops->fiqenable(ec, fiqnr);
-		else
-			printk(KERN_ERR "ecard: rejecting request to "
-				"enable FIQs for %d\n", fiqnr);
-	}
-}
-
-void ecard_disablefiq(unsigned int fiqnr)
-{
-	ecard_t *ec = slot_to_ecard(fiqnr);
-
-	if (ec) {
-		if (!ec->ops)
-			ec->ops = &ecard_default_ops;
-
-		if (ec->ops->fiqdisable)
-			ec->ops->fiqdisable(ec, fiqnr);
-	}
-}
-
 static void ecard_dump_irq_state(void)
 {
 	ecard_t *ec;
-- 
1.7.10.4

