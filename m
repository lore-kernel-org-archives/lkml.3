Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaKAWsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:48:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60233 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbaKAWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mark" <markk@clara.co.uk>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.889051861@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 041/102] storage: Add single-LUN quirk for Jaz USB Adapter
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -733,6 +733,12 @@ UNUSUAL_DEV(  0x059b, 0x0001, 0x0100, 0x
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

