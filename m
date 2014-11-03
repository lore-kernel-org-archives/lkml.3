Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaKCIy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:54:29 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61490 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaKCIy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:54:27 -0500
From: Daniel Dressler <danieru.dressler@gmail.com>
To: Daniel <danieru.dressler@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tommi Rantala <tt.rantala@gmail.com>,
        Ted Mielczarek <ted@mielczarek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frank Razenberg <frank@zzattack.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        Petr Sebor <petr@scssoft.com>,
        Thomaz de Oliveira dos Reis <thor27@gmail.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list), linux-input@vger.kernel.org
Subject: [PATCH 1/1] Input: xpad - update docs to reflect current state
Date: Mon,  3 Nov 2014 17:53:06 +0900
Message-Id: <1415004836-22871-1-git-send-email-danieru.dressler@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last time this documentation was accurate was
just over 8 years ago. In this time we've added
support for two new generations of Xbox console
controllers and dozens of third-party controllers.

This patch unifies terminology and makes it explicit
which model of controller a sentence refers to.

It also expands certain sections to address the latest
versions of Xbox controllers.

Thus this documentation should now be useful to
end users and not contain out-right untruths.

Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
---
 Documentation/input/xpad.txt  | 123 ++++++++++++++++++++++++++++--------------
 drivers/input/joystick/xpad.c |   4 +-
 2 files changed, 85 insertions(+), 42 deletions(-)

diff --git a/Documentation/input/xpad.txt b/Documentation/input/xpad.txt
index 7cc9a43..d1b23f2 100644
--- a/Documentation/input/xpad.txt
+++ b/Documentation/input/xpad.txt
@@ -1,18 +1,22 @@
-xpad - Linux USB driver for X-Box gamepads
+xpad - Linux USB driver for Xbox compatible controllers
 
-This is the very first release of a driver for X-Box gamepads.
-Basically, this was hacked away in just a few hours, so don't expect
-miracles.
+This driver exposes all first-party and third-party Xbox compatible
+controllers. It has a long history and has enjoyed considerable usage
+as Window's xinput library caused most PC games to focus on Xbox
+controller compatibility.
 
-In particular, there is currently NO support for the rumble pack.
-You won't find many ff-aware linux applications anyway.
+Due to backwards compatibility all buttons are reported as digital.
+This only effects Original Xbox controllers. All later controller models
+have only digital face buttons.
+
+Rumble is supported on some models of Xbox 360 controllers but not of
+Original Xbox controllers nor on Xbox One controllers. As of writing
+the Xbox One's rumble protocol has not been reverse engineered but in
+the future could be supported.
 
 
 0. Notes
 --------
-
-Driver updated for kernel 2.6.17.11. (Based on a patch for 2.6.11.4.)
-
 The number of buttons/axes reported varies based on 3 things:
 - if you are using a known controller
 - if you are using a known dance pad
@@ -20,12 +24,16 @@ The number of buttons/axes reported varies based on 3 things:
   module configuration for "Map D-PAD to buttons rather than axes for unknown
   pads" (module option dpad_to_buttons)
 
-If you set dpad_to_buttons to 0 and you are using an unknown device (one
-not listed below), the driver will map the directional pad to axes (X/Y),
-if you said N it will map the d-pad to buttons, which is needed for dance
-style games to function correctly.  The default is Y.
+If you set dpad_to_buttons to N and you are using an unknown device
+the driver will map the directional pad to axes (X/Y).
+If you said Y it will map the d-pad to buttons, which is needed for dance
+style games to function correctly. The default is Y.
+
+dpad_to_buttons has no effect for known pads. A erroneous commit message
+claimed dpad_to_buttons could be used to force behavior on known devices.
+This is not true. Both dpad_to_buttons and triggers_to_buttons only affect
+unknown controllers.
 
-dpad_to_buttons has no effect for known pads.
 
 0.1 Normal Controllers
 ----------------------
@@ -80,17 +88,29 @@ to the list of supported devices, ensuring that it will work out of the
 box in the future.
 
 
-1. USB adapter
+1. USB adapters
 --------------
+All generations of Xbox controllers speak USB over the wire.
+- Original Xbox controllers use a proprietary connector and require adapters.
+- Wireless Xbox 360 controllers require a 'Xbox 360 Wireless Gaming Receiver
+  for Windows'
+- Wired Xbox 360 controllers use standard USB connectors.
+- Xbox One controllers can be wireless but speak Wi-Fi Direct and are not
+  yet supported.
+- Xbox One controllers can be wired and use standard Micro-USB connectors.
+
 
-Before you can actually use the driver, you need to get yourself an
-adapter cable to connect the X-Box controller to your Linux-Box. You
-can buy these online fairly cheap, or build your own.
+
+1.1 Original Xbox USB adapters
+--------------
+Using this driver with an Original Xbox controller requires an
+adapter cable to break out the proprietary connector's pins to USB.
+You can buy these online fairly cheap, or build your own.
 
 Such a cable is pretty easy to build. The Controller itself is a USB
 compound device (a hub with three ports for two expansion slots and
 the controller device) with the only difference in a nonstandard connector
-(5 pins vs. 4 on standard USB connector).
+(5 pins vs. 4 on standard USB 1.0 connectors).
 
 You just need to solder a USB connector onto the cable and keep the
 yellow wire unconnected. The other pins have the same order on both
@@ -102,26 +122,41 @@ original one. You can buy an extension cable and cut that instead. That way,
 you can still use the controller with your X-Box, if you have one ;)
 
 
+
 2. Driver Installation
 ----------------------
 
-Once you have the adapter cable and the controller is connected, you need
-to load your USB subsystem and should cat /proc/bus/usb/devices.
-There should be an entry like the one at the end [4].
+Once you have the adapter cable, if needed, and the controller connected
+the xpad module should be auto loaded. To confirm you can cat
+/proc/bus/usb/devices. There should be an entry like the one at the end [4].
+
+
 
-Currently (as of version 0.0.6), the following devices are included:
- original Microsoft XBOX controller (US), vendor=0x045e, product=0x0202
- smaller  Microsoft XBOX controller (US), vendor=0x045e, product=0x0289
+3. Supported Controllers
+------------------------
+For a full list of supported controllers and associated vendor and product
+IDs see the xpad_device[] array[6].
+
+As of the historic version 0.0.6 (2006-10-10) the following devices
+were supported:
+ original Microsoft XBOX controller (US),    vendor=0x045e, product=0x0202
+ smaller  Microsoft XBOX controller (US),    vendor=0x045e, product=0x0289
  original Microsoft XBOX controller (Japan), vendor=0x045e, product=0x0285
- InterAct PowerPad Pro (Germany), vendor=0x05fd, product=0x107a
- RedOctane Xbox Dance Pad (US), vendor=0x0c12, product=0x8809
+ InterAct PowerPad Pro (Germany),            vendor=0x05fd, product=0x107a
+ RedOctane Xbox Dance Pad (US),              vendor=0x0c12, product=0x8809
+
+Unrecognized models of Xbox controllers should function as Generic
+Xbox controllers. Unrecognized Dance Pad controllers require setting
+the module option 'dpad_to_buttons'.
+
+If you have an unrecognized controller please see 0.3 - Unknown Controllers
 
-The driver should work with xbox pads not listed above as well, however
-you will need to do something extra for dance pads to work.
 
-If you have a controller not listed above, see 0.3 - Unknown Controllers
+4. Manual Testing
+-----------------
+To test this driver's functionality you may use 'jstest'.
 
-If you compiled and installed the driver, test the functionality:
+For example:
 > modprobe xpad
 > modprobe joydev
 > jstest /dev/js0
@@ -134,7 +169,8 @@ show 20 inputs (6 axes, 14 buttons).
 It works? Voila, you're done ;)
 
 
-3. Thanks
+
+5. Thanks
 ---------
 
 I have to thank ITO Takayuki for the detailed info on his site
@@ -145,14 +181,14 @@ His useful info and both the usb-skeleton as well as the iforce input driver
 the basic functionality.
 
 
-4. References
--------------
 
-1. http://euc.jp/periphs/xbox-controller.ja.html (ITO Takayuki)
-2. http://xpad.xbox-scene.com/
-3. http://www.markosweb.com/www/xboxhackz.com/ 
+6. References
+-------------
 
-4. /proc/bus/usb/devices - dump from InterAct PowerPad Pro (Germany):
+[1]: http://euc.jp/periphs/xbox-controller.ja.html (ITO Takayuki)
+[2]: http://xpad.xbox-scene.com/
+[3]: http://www.markosweb.com/www/xboxhackz.com/
+[4]: /proc/bus/usb/devices - dump from InterAct PowerPad Pro (Germany):
 
 T:  Bus=01 Lev=03 Prnt=04 Port=00 Cnt=01 Dev#=  5 Spd=12  MxCh= 0
 D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=32 #Cfgs=  1
@@ -162,7 +198,7 @@ I:  If#= 0 Alt= 0 #EPs= 2 Cls=58(unk. ) Sub=42 Prot=00 Driver=(none)
 E:  Ad=81(I) Atr=03(Int.) MxPS=  32 Ivl= 10ms
 E:  Ad=02(O) Atr=03(Int.) MxPS=  32 Ivl= 10ms
 
-5. /proc/bus/usb/devices - dump from Redoctane Xbox Dance Pad (US):
+[5]: /proc/bus/usb/devices - dump from Redoctane Xbox Dance Pad (US):
 
 T:  Bus=01 Lev=02 Prnt=09 Port=00 Cnt=01 Dev#= 10 Spd=12  MxCh= 0
 D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
@@ -173,7 +209,12 @@ I:  If#= 0 Alt= 0 #EPs= 2 Cls=58(unk. ) Sub=42 Prot=00 Driver=xpad
 E:  Ad=82(I) Atr=03(Int.) MxPS=  32 Ivl=4ms
 E:  Ad=02(O) Atr=03(Int.) MxPS=  32 Ivl=4ms
 
--- 
+[6]: http://lxr.free-electrons.com/ident?i=xpad_device
+
+
+
+7. Historic Edits
+-----------------
 Marko Friedemann <mfr@bmx-chemnitz.de>
 2002-07-16
  - original doc
@@ -181,3 +222,5 @@ Marko Friedemann <mfr@bmx-chemnitz.de>
 Dominic Cerquetti <binary1230@yahoo.com>
 2005-03-19
  - added stuff for dance pads, new d-pad->axes mappings
+
+Later changes may be viewed with 'git log Documentation/input/xpad.txt'
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 2ed7905..7e2e047 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -40,8 +40,8 @@
  *
  * TODO:
  *  - fine tune axes (especially trigger axes)
- *  - fix "analog" buttons (reported as digital now)
- *  - get rumble working
+ *  - add original xbox rumble pack support
+ *  - add xbox one rumble support
  *  - need USB IDs for other dance pads
  *
  * History:
-- 
2.1.0

