Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3AYNXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:23:32 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:36635 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab3AYNXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:30 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/25] Support of Nexio 42" and new default class for hid-multitouch
Date: Fri, 25 Jan 2013 14:22:45 +0100
Message-Id: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

finally, I managed to send a new bunch of patches. Sorry for the delay from the
previous version, but meanwhile, I implemented an automatic regressions tests
for hid device [1].
So this series seems pretty big, but it does not break any known devices (I ran
40 successful tests for this series)[2].

To sum up:
- Nexio devices were problematic in the sense they use out of range values for
some of the fields, and consider that the driver won't treat the extra touches
based on the reported contact count.
- fortunately, this behavior (relying on contact count) is compatible with all
the devices I know, which leads to think that this is how the Windows 7/8 driver
manage to handle such a different bunch of devices.
- thanks to the automatic testing, I was able to fix broken devices
(Sharp LC-20FE1-W screen 04dd:9681, Sitronix 1403:5001 and Cando 2087:0a02)
and optimize many others. In order to allow a bisection to be done, I split
the patches in many different ones, one per device type.
- finally, I changed the default class in order to handle the new devices in a
better way.

Cheers,
Benjamin

[1] https://github.com/bentiss/hid-test
[2] https://github.com/bentiss/hid-devices

Benjamin Tissoires (25):
  HID: break out hid_extract_field
  HID: multitouch: add support for Nexio 42" panel
  HID: multitouch: fix Win8 protocol for Sharp like devices
  HID: multitouch: ensure that serial devices make no use of contact count
  HID: multitouch: fix protocol for Sitronix 1403:5001
  HID: multitouch: optimize FlatFrog panels
  HID: multitouch: optimize 3M panels
  HID: multitouch: optimize Cypress panels
  HID: multitouch: optimize eGalax panels
  HID: multitouch: optimize Stantum panels
  HID: multitouch: optimize Quanta panels
  HID: multitouch: optimize Lumio panels
  HID: multitouch: optimize MosArt panels
  HID: multitouch: optimize Elo panels
  HID: multitouch: optimize Hanvon panels
  HID: multitouch: optimize IRTouch panels
  HID: multitouch: fix protocol for Cando 2087:0a02
  HID: multitouch: optimize Cando panels
  HID: multitouch: optimize ActionStar panels
  HID: multitouch: optimize Atmel panels
  HID: multitouch: optimize Ideacom panels
  HID: multitouch: optimize LG panels
  HID: multitouch: optimize Nexio panels
  HID: multitouch: remove useless DUAL_NSMU_CONTACTID class
  HID: multitouch: make MT_CLS_ALWAYS_TRUE the new default class

 drivers/hid/hid-core.c       |  60 +++++++++----
 drivers/hid/hid-ids.h        |   3 +
 drivers/hid/hid-multitouch.c | 206 ++++++++++++++++++++++++++++++-------------
 include/linux/hid.h          |   1 +
 4 files changed, 189 insertions(+), 81 deletions(-)

-- 
1.8.1

