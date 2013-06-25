Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3FYSvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:51:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3FYSeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shawn Joseph <jms.576@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 84/95] Input: xpad - fix for "Mad Catz Street Fighter IV FightPad" controllers
Date: Tue, 25 Jun 2013 11:33:11 -0700
Message-Id: <20130625182203.113715280@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Joseph <jms.576@gmail.com>

commit be66227151c0cd4da536098c3ee07809101c6faa upstream.

Added MAP_TRIGGERS_TO_BUTTONS for Mad Catz Street Fighter IV FightPad
device. This controller model was already supported by the xpad
driver, but none of the buttons work correctly without this change.

Tested on kernel version 3.9.5.

Signed-off-by: Shawn Joseph <jms.576@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -137,7 +137,7 @@ static const struct xpad_device {
 	{ 0x0738, 0x4540, "Mad Catz Beat Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", 0, XTYPE_XBOX },
 	{ 0x0738, 0x4716, "Mad Catz Wired Xbox 360 Controller", 0, XTYPE_XBOX360 },
-	{ 0x0738, 0x4728, "Mad Catz Street Fighter IV FightPad", XTYPE_XBOX360 },
+	{ 0x0738, 0x4728, "Mad Catz Street Fighter IV FightPad", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x0738, 0x4738, "Mad Catz Wired Xbox 360 Controller (SFIV)", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x0738, 0x6040, "Mad Catz Beat Pad Pro", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x0738, 0xbeef, "Mad Catz JOYTECH NEO SE Advanced GamePad", XTYPE_XBOX360 },


