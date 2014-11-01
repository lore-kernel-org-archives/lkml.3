Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaKAWvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:51:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbaKAWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:29 -0400
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
Message-ID: <lsq.1414880883.71398723@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 057/102] USB: storage: Add quirk for Adaptec
 USBConnect 2000 USB-to-SCSI Adapter
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -93,6 +93,12 @@ UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x
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

