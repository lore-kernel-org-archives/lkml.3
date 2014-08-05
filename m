Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaHEPIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaHEPIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:08:34 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH] Input - wacom: only register once the MODULE_* macros
Date: Tue,  5 Aug 2014 11:08:12 -0400
Message-Id: <1407251292-10177-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Putting the various MODULE_* makes them appear several times in modinfo
because wacom.h is used both in wacom_sys.c and wacom_wac.h.
Having the macros near the module declaration makes them appear only once.

Add also MODULE_VERSION(DRIVER_VERSION) to export the current version
number.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Dmitry,

I guess this one could sneak on top of your pull request too.
If not, then I'll push Jiri to take it in one of the future rc :)

Cheers,
Benjamin

 drivers/hid/wacom.h     | 4 ----
 drivers/hid/wacom_sys.c | 5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index 8cc4406..64bc1b2 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -101,10 +101,6 @@
 #define DRIVER_DESC "USB Wacom tablet driver"
 #define DRIVER_LICENSE "GPL"
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE(DRIVER_LICENSE);
-
 #define USB_VENDOR_ID_WACOM	0x056a
 #define USB_VENDOR_ID_LENOVO	0x17ef
 
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 6e0c191..ff4ec50 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1437,6 +1437,11 @@ static int wacom_reset_resume(struct hid_device *hdev)
 	return wacom_resume(hdev);
 }
 
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE(DRIVER_LICENSE);
+
 static struct hid_driver wacom_driver = {
 	.name =		"wacom",
 	.id_table =	wacom_ids,
-- 
2.0.4

