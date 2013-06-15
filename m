Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3FONdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:33:10 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:34226 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3FONdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:33:07 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: jkosina@suse.cz, dmitry.torokhov@gmail.com,
        Todd Showalter <todd@electronjump.com>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 0/2] GamePad: Wii U Pro Controller Support
Date: Sat, 15 Jun 2013 15:32:43 +0200
Message-Id: <1371303165-1802-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2nd revision of the pro-controller patches. The first patch introduces a
gamepad-API documentation as discussed on the mailing-list. The second patch
adds support for the Pro-Controller based on this gamepad-API.

Note that the 2nd patch depends on the 1st so they should go through the same
maintainer's tree.


Regarding the Pro-Controller: The new data reports are handled as usual as a new
wiimote-extension. However, we also add device-detection for it so we don't load
all the other unavailable interfaces on it. This makes the gamepad behave like
any other gamepad-driver without the wiimote specifics.
No user-space library is needed, but libxwiimote and xwiishow already include
support for it (if someone wants to integrate it into existing wiimote apps).


Cheers
David


David Herrmann (2):
  input: document gamepad API and add extra keycodes
  HID: wiimote: support Nintendo Wii U Pro Controller

 Documentation/input/gamepad.txt   | 156 ++++++++++++++++++++
 drivers/hid/hid-wiimote-core.c    |  23 +++
 drivers/hid/hid-wiimote-modules.c | 295 ++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-wiimote.h         |   2 +
 include/uapi/linux/input.h        |   9 ++
 5 files changed, 485 insertions(+)
 create mode 100644 Documentation/input/gamepad.txt

-- 
1.8.3.1

