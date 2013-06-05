Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab3FESBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:01:45 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:20677 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757054Ab3FERsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:10 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 03/53] Input: atmel_mxt_ts - Return IRQ_NONE when interrupt handler fails
Date: Wed,  5 Jun 2013 18:36:56 +0100
Message-Id: <1370453866-16534-4-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 6702175..2a06657 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -591,7 +591,7 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	do {
 		if (mxt_read_message(data, &message)) {
 			dev_err(dev, "Failed to read message\n");
-			goto end;
+			return IRQ_NONE;
 		}
 
 		reportid = message.reportid;
@@ -618,7 +618,6 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 		input_sync(data->input_dev);
 	}
 
-end:
 	return IRQ_HANDLED;
 }
 
-- 
1.7.10.4

