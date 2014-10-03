Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbaJDAjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:39:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaJCVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Knibbs <markk@clara.co.uk>
Subject: [PATCH 3.16 135/357] storage: Add single-LUN quirk for Jaz USB Adapter
Date: Fri,  3 Oct 2014 14:28:41 -0700
Message-Id: <20141003212937.525777007@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -741,6 +741,12 @@ UNUSUAL_DEV(  0x059b, 0x0001, 0x0100, 0x
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


