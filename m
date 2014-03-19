Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200AbaCSNKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:10:40 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50142 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbaCSNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:10:37 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fugang Duan <B38611@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Budig <simon.budig@kernelconcepts.de>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCHv4 4/5] Input: edt-ft5x06: Ignore touchdown events
Date: Wed, 19 Mar 2014 14:09:22 +0100
Message-Id: <1395234563-11034-5-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chip may report invalid coordinates on touchdown events, so don't
report the initial touchdown event.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/input/touchscreen/edt-ft5x06.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 27dccfc..af736e4 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -175,6 +175,10 @@ static irqreturn_t edt_ft5x06_ts_isr(int irq, void *dev_id)
 		if (type == TOUCH_EVENT_RESERVED)
 			continue;
 
+		/* ignore TOUCH_DOWN events, might have bogus coordinates */
+		if (type == TOUCH_EVENT_DOWN)
+			continue;
+
 		x = ((buf[0] << 8) | buf[1]) & 0x0fff;
 		y = ((buf[2] << 8) | buf[3]) & 0x0fff;
 		id = (buf[2] >> 4) & 0x0f;
-- 
1.7.10.4

