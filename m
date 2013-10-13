Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3JMGLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:11:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56246 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670Ab3JMGLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:11:15 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: david@hardeman.nu, m.chehab@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] winbond-cir: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:11:12 +0200
Message-Id: <1381644672-9283-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/rc/winbond-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 98bd496..904baf4 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1110,7 +1110,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	}
 
 	err = request_irq(data->irq, wbcir_irq_handler,
-			  IRQF_DISABLED, DRVNAME, device);
+			  0, DRVNAME, device);
 	if (err) {
 		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
 		err = -EBUSY;
-- 
1.8.1.2

