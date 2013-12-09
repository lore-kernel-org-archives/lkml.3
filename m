Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab3LIKLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:11:40 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34422 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245Ab3LIKLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:11:37 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ballabio_dario@emc.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] u14-34f: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 11:11:33 +0100
Message-Id: <1386583893-5282-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381040188-12560-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381040188-12560-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/u14-34f.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 9c216e563568..5a03bb3bcfef 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -873,7 +873,7 @@ static int port_detect \
 
    /* Board detected, allocate its IRQ */
    if (request_irq(irq, do_interrupt_handler,
-             IRQF_DISABLED | ((subversion == ESA) ? IRQF_SHARED : 0),
+             (subversion == ESA) ? IRQF_SHARED : 0,
              driver_name, (void *) &sha[j])) {
       printk("%s: unable to allocate IRQ %u, detaching.\n", name, irq);
       goto freelock;
-- 
1.8.3.2

