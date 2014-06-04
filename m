Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaFEAVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:21:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFDXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 133/228] Input: Add INPUT_PROP_TOPBUTTONPAD device property
Date: Wed,  4 Jun 2014 16:22:42 -0700
Message-Id: <20140604232352.288707973@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/input.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -164,6 +164,7 @@ struct input_keymap_entry {
 #define INPUT_PROP_DIRECT		0x01	/* direct input devices */
 #define INPUT_PROP_BUTTONPAD		0x02	/* has button(s) under pad */
 #define INPUT_PROP_SEMI_MT		0x03	/* touch rectangle only */
+#define INPUT_PROP_TOPBUTTONPAD		0x04	/* softbuttons at top of pad */
 
 #define INPUT_PROP_MAX			0x1f
 #define INPUT_PROP_CNT			(INPUT_PROP_MAX + 1)


