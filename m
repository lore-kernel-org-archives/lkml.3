Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3BOTf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:35:56 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:48563 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3BOTfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:35:53 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au9BAEmNHlFV5qjOPGdsb2JhbABEiwC0d3wXAwEBAQE4NIIgAQUnLxMBDxAISTkKFAYTiBa9PhWNRoFQB4NAA5wojV2BaA
X-IronPort-AV: E=Sophos;i="4.84,675,1355094000"; 
   d="scan'208";a="281680514"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/2] Input: synaptics - initialize pointer emulation usage
Date: Fri, 15 Feb 2013 20:36:21 +0100
Message-Id: <1360956981-1112-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360956981-1112-1-git-send-email-rydberg@euromail.se>
References: <1360956981-1112-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To properly setup event parameters for emulated events, pass
the appropriate flag to the slot initialization function. Also,
all MT-related events should be setup before initialization.

Incidentally, this solves the issue of doubly filtered pointer
events.

Reported-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Daniel,

This patch has only been compile tested, but chances are that it will
work for you, together with the previous patch.

Cheers,
Henrik

 drivers/input/mouse/synaptics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 12d12ca..a8590ad 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1247,11 +1247,11 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
 
 	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
-		input_mt_init_slots(dev, 2, 0);
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
 					ABS_MT_POSITION_Y);
 		/* Image sensors can report per-contact pressure */
 		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
+		input_mt_init_slots(dev, 2, INPUT_MT_POINTER);
 
 		/* Image sensors can signal 4 and 5 finger clicks */
 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
-- 
1.8.1.2

