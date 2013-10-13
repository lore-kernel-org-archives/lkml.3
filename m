Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3JMGFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:05:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56232 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670Ab3JMGFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:05:14 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: edubezval@gmail.com, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] radio-si4713: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:05:11 +0200
Message-Id: <1381644311-9151-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/radio/si4713-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index fe16088..9ec48cc 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1456,7 +1456,7 @@ static int si4713_probe(struct i2c_client *client,
 
 	if (client->irq) {
 		rval = request_irq(client->irq,
-			si4713_handler, IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			si4713_handler, IRQF_TRIGGER_FALLING,
 			client->name, sdev);
 		if (rval < 0) {
 			v4l2_err(&sdev->sd, "Could not request IRQ\n");
-- 
1.8.1.2

