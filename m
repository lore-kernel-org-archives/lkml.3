Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081Ab3IGHiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 03:38:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49802 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000Ab3IGHiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 03:38:23 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] sparc: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 09:38:09 +0200
Message-Id: <1378539489-7607-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from sparc architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/sparc/include/asm/floppy_64.h | 2 +-
 arch/sparc/kernel/ldc.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/floppy_64.h b/arch/sparc/include/asm/floppy_64.h
index e204f90..7c90c50 100644
--- a/arch/sparc/include/asm/floppy_64.h
+++ b/arch/sparc/include/asm/floppy_64.h
@@ -254,7 +254,7 @@ static int sun_fd_request_irq(void)
 		once = 1;
 
 		error = request_irq(FLOPPY_IRQ, sparc_floppy_irq,
-				    IRQF_DISABLED, "floppy", NULL);
+				    0, "floppy", NULL);
 
 		return ((error == 0) ? 0 : -1);
 	}
diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index 54df554..e01d75d 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -1249,12 +1249,12 @@ int ldc_bind(struct ldc_channel *lp, const char *name)
 	snprintf(lp->rx_irq_name, LDC_IRQ_NAME_MAX, "%s RX", name);
 	snprintf(lp->tx_irq_name, LDC_IRQ_NAME_MAX, "%s TX", name);
 
-	err = request_irq(lp->cfg.rx_irq, ldc_rx, IRQF_DISABLED,
+	err = request_irq(lp->cfg.rx_irq, ldc_rx, 0,
 			  lp->rx_irq_name, lp);
 	if (err)
 		return err;
 
-	err = request_irq(lp->cfg.tx_irq, ldc_tx, IRQF_DISABLED,
+	err = request_irq(lp->cfg.tx_irq, ldc_tx, 0,
 			  lp->tx_irq_name, lp);
 	if (err) {
 		free_irq(lp->cfg.rx_irq, lp);
-- 
1.8.1.2

