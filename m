Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaK0JKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:10:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:41680 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbaK0Ir3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:29 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark <markk@clara.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 34/91] storage: Add single-LUN quirk for Jaz USB Adapter
Date: Thu, 27 Nov 2014 16:42:17 +0800
Message-Id: <1417077794-9299-34-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark <markk@clara.co.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit c66f1c62e85927357e7b3f4c701614dcb5c498a2 upstream.

The Iomega Jaz USB Adapter is a SCSI-USB converter cable. The hardware
seems to be identical to e.g. the Microtech XpressSCSI, using a Shuttle/
SCM chip set. However its firmware restricts it to only work with Jaz
drives.

On connecting the cable a message like this appears four times in the log:
 reset full speed USB device number 4 using uhci_hcd

That's non-fatal but the US_FL_SINGLE_LUN quirk fixes it.

Signed-off-by: Mark Knibbs <markk@clara.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1d9fc30..813422e 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -733,6 +733,12 @@ UNUSUAL_DEV(  0x059b, 0x0001, 0x0100, 0x0100,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_SINGLE_LUN ),
 
+UNUSUAL_DEV(  0x059b, 0x0040, 0x0100, 0x0100,
+		"Iomega",
+		"Jaz USB Adapter",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_SINGLE_LUN ),
+
 /* Reported by <Hendryk.Pfeiffer@gmx.de> */
 UNUSUAL_DEV(  0x059f, 0x0643, 0x0000, 0x0000,
 		"LaCie",
-- 
1.9.1

