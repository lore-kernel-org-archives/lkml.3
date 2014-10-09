Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbaJIVKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:10:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59524 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbaJIVKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Knibbs <markk@clara.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 055/163] storage: Add single-LUN quirk for Jaz USB Adapter
Date: Thu,  9 Oct 2014 14:01:20 -0700
Message-Id: <1412888588-26755-56-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index e2d0050..d168f51 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -741,6 +741,12 @@ UNUSUAL_DEV(  0x059b, 0x0001, 0x0100, 0x0100,
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

