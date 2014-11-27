Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaK0Ism (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:42234 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbaK0Isi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:38 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 52/91] USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI adapter
Date: Thu, 27 Nov 2014 16:42:35 +0800
Message-Id: <1417077794-9299-52-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark <markk@clara.co.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit b6a3ed677991558ce09046397a7c4d70530d15b3 upstream.

Hi,

The Ariston Technologies iConnect 025 and iConnect 050 (also known as e.g.
iSCSI-50) are SCSI-USB converters which use Shuttle Technology/SCM
Microsystems chips. Only the connectors differ; both have the same USB ID.
The US_FL_SCM_MULT_TARG quirk is required to use SCSI devices with ID other
than 0.

I don't have one of these, but based on the other entries for Shuttle/
SCM-based converters this patch is very likely correct. I used 0x0000 and
0x9999 for bcdDeviceMin and bcdDeviceMax because I'm not sure which
bcdDevice value the products use.

Signed-off-by: Mark Knibbs <markk@clara.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 18a9522..8642da6 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1952,6 +1952,12 @@ UNUSUAL_DEV(  0x177f, 0x0400, 0x0000, 0x0000,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
 
+UNUSUAL_DEV(  0x1822, 0x0001, 0x0000, 0x9999,
+		"Ariston Technologies",
+		"iConnect USB to SCSI adapter",
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
+		US_FL_SCM_MULT_TARG ),
+
 /* Reported by Hans de Goede <hdegoede@redhat.com>
  * These Appotech controllers are found in Picture Frames, they provide a
  * (buggy) emulation of a cdrom drive which contains the windows software
-- 
1.9.1

