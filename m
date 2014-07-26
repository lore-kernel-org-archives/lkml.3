Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaGZA17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:27:59 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60606 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaGZA16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:27:58 -0400
Date: Fri, 25 Jul 2014 17:27:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: synaptics - properly initialize slots for semi-MT
Message-ID: <20140726002751.GA16660@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semi-MT devices are pointers too, so let's tell that to
input_mt_init_slots(), as well as let it set up the devices as semi-MT,
instead of us doing it manually.

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mouse/synaptics.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index ef9e0b8..fe607e9 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1371,11 +1371,11 @@ static void set_input_params(struct psmouse *psmouse,
 		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
 		__set_bit(BTN_TOOL_QUINTTAP, dev->keybit);
 	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
-		/* Non-image sensors with AGM use semi-mt */
-		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
-		input_mt_init_slots(dev, 2, 0);
 		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
 					ABS_MT_POSITION_Y);
+		/* Non-image sensors with AGM use semi-mt */
+		input_mt_init_slots(dev, 2,
+				    INPUT_MT_POINTER | INPUT_MT_SEMI_MT);
 	}
 
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
-- 
2.0.0.526.g5318336


-- 
Dmitry
