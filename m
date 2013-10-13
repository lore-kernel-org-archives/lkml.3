Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3JMDx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 23:53:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55989 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753077Ab3JMDx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 23:53:58 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] hpet: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 05:53:47 +0200
Message-Id: <1381636427-5877-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/char/hpet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 448ce5e..3becd6e 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -486,8 +486,7 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 		}
 
 		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
-		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
-						? IRQF_SHARED : IRQF_DISABLED;
+		irq_flags = devp->hd_flags & HPET_SHARED_IRQ ? IRQF_SHARED : 0;
 		if (request_irq(irq, hpet_interrupt, irq_flags,
 				devp->hd_name, (void *)devp)) {
 			printk(KERN_ERR "hpet: IRQ %d is not free\n", irq);
-- 
1.8.1.2

