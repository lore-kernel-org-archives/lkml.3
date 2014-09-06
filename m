Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaIFMzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 08:55:43 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:50926 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbaIFMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 08:55:38 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2014 08:55:37 EDT
Date: Sat, 6 Sep 2014 14:47:27 +0200
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ted Mielczarek <ted@mielczarek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] xpad: sync device IDs with xboxdrv
Message-ID: <20140906144727.29b44f5a@rechenknecht2k7>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: 77.12.110.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace xboxdrv driver knows some more device ids than the kernel.
This patch adds the missing xbox gamepads from [1] to xpad.c

[1] https://github.com/Grumbel/xboxdrv/blob/master/src/xpad_device.cpp

Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
---
 drivers/input/joystick/xpad.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 177602c..5ebf37d 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -126,7 +126,9 @@ static const struct xpad_device {
 	{ 0x045e, 0x0291, "Xbox 360 Wireless Receiver (XBOX)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x045e, 0x0719, "Xbox 360 Wireless Receiver", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
+	{ 0x044f, 0xb326, "Thrustmaster Gamepad GP XID", 0, XTYPE_XBOX360 },
 	{ 0x046d, 0xc21d, "Logitech Gamepad F310", 0, XTYPE_XBOX360 },
+	{ 0x046d, 0xc21e, "Logitech Gamepad F510", 0, XTYPE_XBOX360 },
 	{ 0x046d, 0xc21f, "Logitech Gamepad F710", 0, XTYPE_XBOX360 },
 	{ 0x046d, 0xc242, "Logitech Chillstream Controller", 0, XTYPE_XBOX360 },
 	{ 0x046d, 0xca84, "Logitech Xbox Cordless Controller", 0, XTYPE_XBOX },
@@ -140,10 +142,17 @@ static const struct xpad_device {
 	{ 0x0738, 0x4540, "Mad Catz Beat Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x0738, 0x4556, "Mad Catz Lynx Wireless Controller", 0, XTYPE_XBOX },
 	{ 0x0738, 0x4716, "Mad Catz Wired Xbox 360 Controller", 0, XTYPE_XBOX360 },
+	{ 0x0738, 0x4718, "Mad Catz Street Fighter IV FightStick SE", 0, XTYPE_XBOX360 },
+	{ 0x0738, 0x4726, "Mad Catz Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0x4728, "Mad Catz Street Fighter IV FightPad", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x0738, 0x4738, "Mad Catz Wired Xbox 360 Controller (SFIV)", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
+	{ 0x0738, 0x4740, "Mad Catz Beat Pad", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0x6040, "Mad Catz Beat Pad Pro", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x0738, 0xb726, "Mad Catz Xbox controller - MW2", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0xbeef, "Mad Catz JOYTECH NEO SE Advanced GamePad", XTYPE_XBOX360 },
+	{ 0x0738, 0xcb02, "Saitek Cyborg Rumble Pad - PC/Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x0738, 0xcb03, "Saitek P3200 Rumble Pad - PC/Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x0738, 0xf738, "Super SFIV FightStick TE S", 0, XTYPE_XBOX360 },
 	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", DANCEPAD_MAP_CONFIG, XTYPE_XBOX },
 	{ 0x0c12, 0x880a, "Pelican Eclipse PL-2023", 0, XTYPE_XBOX },
@@ -156,28 +165,49 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0005, "Eclipse wireless Controller", 0, XTYPE_XBOX },
 	{ 0x0e6f, 0x0006, "Edge wireless Controller", 0, XTYPE_XBOX },
 	{ 0x0e6f, 0x0105, "HSM3 Xbox360 dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
+	{ 0x0e6f, 0x0113, "Afterglow AX.1 Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0201, "Pelican PL-3601 'TSZ' Wired Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0213, "Afterglow Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x0e6f, 0x021f, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x0e6f, 0x0301, "Logic3 Controller", 0, XTYPE_XBOX360 },
+	{ 0x0e6f, 0x0401, "Logic3 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0e8f, 0x0201, "SmartJoy Frag Xpad/PS2 adaptor", 0, XTYPE_XBOX },
+	{ 0x0e8f, 0x3008, "Generic xbox control (dealextreme)", 0, XTYPE_XBOX },
+	{ 0x0f0d, 0x000a, "Hori Co. DOA4 FightStick", 0, XTYPE_XBOX360 },
 	{ 0x0f0d, 0x000d, "Hori Fighting Stick EX2", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x0f0d, 0x0016, "Hori Real Arcade Pro.EX", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x0f30, 0x0202, "Joytech Advanced Controller", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", 0, XTYPE_XBOX },
 	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", 0, XTYPE_XBOX },
 	{ 0x12ab, 0x0004, "Honey Bee Xbox360 dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
+	{ 0x12ab, 0x0301, "PDP AFTERGLOW AX.1", 0, XTYPE_XBOX360 },
 	{ 0x12ab, 0x8809, "Xbox DDR dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x1430, 0x4748, "RedOctane Guitar Hero X-plorer", 0, XTYPE_XBOX360 },
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0, XTYPE_XBOX360 },
+	{ 0x1532, 0x0037, "Razer Sabertooth", 0, XTYPE_XBOX360 },
+	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
+	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
+	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },
+	{ 0x162e, 0xbeef, "Joytech Neo-Se Take2", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd00, "Razer Onza Tournament Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd01, "Razer Onza Classic Edition", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0xf016, "Mad Catz Xbox 360 Controller", 0, XTYPE_XBOX360 },
+	{ 0x1bad, 0xf023, "MLG Pro Circuit Controller (Xbox)", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xf028, "Street Fighter IV FightPad", 0, XTYPE_XBOX360 },
+	{ 0x1bad, 0xf038, "Street Fighter IV FightStick TE", 0, XTYPE_XBOX360 },
+	{ 0x1bad, 0xf900, "Harmonix Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xf901, "Gamestop Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xf903, "Tron Xbox 360 controller", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5000, "Razer Atrox Arcade Stick", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5300, "PowerA MINI PROEX Controller", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5303, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5500, "Hori XBOX 360 EX 2 with Turbo", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5501, "Hori Real Arcade Pro VX-SA", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5506, "Hori SOULCALIBUR V Stick", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5b02, "Thrustmaster, Inc. GPX Controller", 0, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
 };
@@ -274,6 +304,9 @@ static struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x0f0d),		/* Hori Controllers */
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
 	XPAD_XBOX360_VENDOR(0x24c6),		/* PowerA Controllers */
+	XPAD_XBOX360_VENDOR(0x1532),		/* Razer Sabertooth */
+	XPAD_XBOX360_VENDOR(0x15e4),		/* Numark X-Box 360 controllers */
+	XPAD_XBOX360_VENDOR(0x162e),		/* Joytech X-Box 360 controllers */
 	{ }
 };
 
