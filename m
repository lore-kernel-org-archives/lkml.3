Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaJIVJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59370 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586AbaJIVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Knibbs <markk@clara.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 112/163] USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
Date: Thu,  9 Oct 2014 14:02:17 -0700
Message-Id: <1412888588-26755-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark <markk@clara.co.uk>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index d168f51..e0fdb52 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -101,6 +101,12 @@ UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x0001,
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

