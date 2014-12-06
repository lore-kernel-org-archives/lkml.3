Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaLFPUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:20 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47653 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752118AbaLFPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 03/66] Input: Add INPUT_PROP_TOPBUTTONPAD device property
Date: Sat,  6 Dec 2014 16:06:55 +0100
Message-Id: <a4e2b94ab9353230fe45187ee0c15a2fc9195fc3.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f37c013409bb78ebb958821aa10d069e707cabac upstream.

On some newer laptops with a trackpoint the physical buttons for the
trackpoint have been removed to allow for a larger touchpad. On these
laptops the buttonpad has clearly marked areas on the top which are to be
used as trackpad buttons.

Users of the event device-node need to know about this, so that they can
properly interpret BTN_LEFT events as being a left / right / middle click
depending on where on the button pad the clicking finger is.

This commits adds a INPUT_PROP_TOPBUTTONPAD device property which drivers
for such buttonpads will use to signal to the user that this buttonpad not
only has the normal bottom button area, but also a top button area.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/input.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index a3726275876d..f30db096455f 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -164,6 +164,7 @@ struct input_keymap_entry {
 #define INPUT_PROP_DIRECT		0x01	/* direct input devices */
 #define INPUT_PROP_BUTTONPAD		0x02	/* has button(s) under pad */
 #define INPUT_PROP_SEMI_MT		0x03	/* touch rectangle only */
+#define INPUT_PROP_TOPBUTTONPAD		0x04	/* softbuttons at top of pad */
 
 #define INPUT_PROP_MAX			0x1f
 #define INPUT_PROP_CNT			(INPUT_PROP_MAX + 1)
-- 
2.1.3

