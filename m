Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaIIOxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:53:18 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:23208 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752553AbaIIOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:50:59 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 1/2] Input: atmel_mxt_ts - downgrade warning about empty interrupts
Date: Tue,  9 Sep 2014 15:50:48 +0100
Message-Id: <1410274249-3469-2-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410274249-3469-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1410274249-3469-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

In the case where the CHG/interrupt line mode is not configured correctly,
this warning is output to dmesg output for each interrupt. Downgrade the
message to debug.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index db178ed..d954b81 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -837,7 +837,12 @@ static irqreturn_t mxt_process_messages_t44(struct mxt_data *data)
 	count = data->msg_buf[0];
 
 	if (count == 0) {
-		dev_warn(dev, "Interrupt triggered but zero messages\n");
+		/*
+		 * This condition is caused by the CHG line being configured
+		 * in Mode 0. It results in unnecessary I2C operations but it
+		 * is benign.
+		 */
+		dev_dbg(dev, "Interrupt triggered but zero messages\n");
 		return IRQ_NONE;
 	} else if (count > data->max_reportid) {
 		dev_err(dev, "T44 count %d exceeded max report id\n", count);
-- 
1.9.1

