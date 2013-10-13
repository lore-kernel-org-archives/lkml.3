Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3JMGNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:13:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56258 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726Ab3JMGNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:13:35 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] misc: arm-charlcd: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:13:31 +0200
Message-Id: <1381644811-9341-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/misc/arm-charlcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/arm-charlcd.c b/drivers/misc/arm-charlcd.c
index 1256a4b..b7ebf80 100644
--- a/drivers/misc/arm-charlcd.c
+++ b/drivers/misc/arm-charlcd.c
@@ -297,7 +297,7 @@ static int __init charlcd_probe(struct platform_device *pdev)
 	lcd->irq = platform_get_irq(pdev, 0);
 	/* If no IRQ is supplied, we'll survive without it */
 	if (lcd->irq >= 0) {
-		if (request_irq(lcd->irq, charlcd_interrupt, IRQF_DISABLED,
+		if (request_irq(lcd->irq, charlcd_interrupt, 0,
 				DRIVERNAME, lcd)) {
 			ret = -EIO;
 			goto out_no_irq;
-- 
1.8.1.2

