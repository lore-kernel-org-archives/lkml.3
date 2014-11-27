Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaK0Isi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:42207 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbaK0Isg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:36 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 51/91] USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
Date: Thu, 27 Nov 2014 16:42:34 +0800
Message-Id: <1417077794-9299-51-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark <markk@clara.co.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 67d365a57a51fb9dece6a5ceb504aa381cae1e5b upstream.

The Adaptec USBConnect 2000 is another SCSI-USB converter which uses
Shuttle Technology/SCM Microsystems chips. The US_FL_SCM_MULT_TARG quirk is
required to use SCSI devices with ID other than 0.

I don't have a USBConnect 2000, but based on the other entries for Shuttle/
SCM-based converters this patch is very likely correct. I used 0x0000 and
0x9999 for bcdDeviceMin and bcdDeviceMax because I'm not sure which
bcdDevice value the product uses.

Signed-off-by: Mark Knibbs <markk@clara.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 813422e..18a9522 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -93,6 +93,12 @@ UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x0001,
 		"PhotoSmart R707",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_FIX_CAPACITY),
 
+UNUSUAL_DEV(  0x03f3, 0x0001, 0x0000, 0x9999,
+		"Adaptec",
+		"USBConnect 2000",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Reported by Sebastian Kapfer <sebastian_kapfer@gmx.net>
  * and Olaf Hering <olh@suse.de> (different bcd's, same vendor/product)
  * for USB floppies that need the SINGLE_LUN enforcement.
-- 
1.9.1

