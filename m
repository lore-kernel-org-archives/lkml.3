Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FREih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:38:37 -0400
Received: from mail-wg0-f66.google.com ([74.125.82.66]:60671 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3FREif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:38:35 -0400
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 00:38:33 -0400
Message-ID: <CAARGL_Gi99=fwW+JGN=-MW3vLA8=h5=oVRopR3Vzpe28Cb8SXg@mail.gmail.com>
Subject: [PATCH] input/joystick: Fix for xpad driver support of "Mad Catz
 Street Fighter IV FightPad" controllers
From: Shawn <jms.576@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: shawn joseph <jms.576@gmail.com>

Added MAP_TRIGGERS_TO_BUTTONS for Mad Catz Street Fighter IV FightPad
device. This controller model was already supported by the xpad
driver, but none of the buttons work correctly without this change.
Tested on kernel version 3.9.5.
Signed-off-by: shawn joseph <jms.576@gmail.com>
---
--- linux-3.9.5/drivers/input/
joystick/xpad.c.orig      2013-06-16 15:09:47.974170141 -0400
+++ linux-3.9.5/drivers/input/joystick/xpad.c   2013-06-16
15:10:24.070611282 -0400
@@ -137,7 +137,7 @@ static const struct xpad_device {
        { 0x0738, 0x4540, "Mad Catz Beat Pad", MAP_DPAD_TO_BUTTONS,
XTYPE_XBOX },
        { 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", 0, XTYPE_XBOX },
        { 0x0738, 0x4716, "Mad Catz Wired Xbox 360 Controller", 0,
XTYPE_XBOX360 },
-       { 0x0738, 0x4728, "Mad Catz Street Fighter IV FightPad",
XTYPE_XBOX360 },
+       { 0x0738, 0x4728, "Mad Catz Street Fighter IV FightPad",
MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
        { 0x0738, 0x4738, "Mad Catz Wired Xbox 360 Controller (SFIV)",
MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
        { 0x0738, 0x6040, "Mad Catz Beat Pad Pro",
MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
        { 0x0738, 0xbeef, "Mad Catz JOYTECH NEO SE Advanced GamePad",
XTYPE_XBOX360 },
