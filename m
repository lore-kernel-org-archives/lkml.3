Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JMGIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:08:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56241 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120Ab3JMGIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:08:42 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] ir-rx51: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:08:36 +0200
Message-Id: <1381644516-9215-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/rc/ir-rx51.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 31b955b..b1e19a2 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -201,8 +201,7 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
 
 	lirc_rx51->irq_num = omap_dm_timer_get_irq(lirc_rx51->pulse_timer);
 	retval = request_irq(lirc_rx51->irq_num, lirc_rx51_interrupt_handler,
-			     IRQF_DISABLED | IRQF_SHARED,
-			     "lirc_pulse_timer", lirc_rx51);
+			     IRQF_SHARED, "lirc_pulse_timer", lirc_rx51);
 	if (retval) {
 		dev_err(lirc_rx51->dev, ": Failed to request interrupt line\n");
 		goto err2;
-- 
1.8.1.2

