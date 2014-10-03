Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbaJDAgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:36:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaJCVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Knibbs <markk@clara.co.uk>
Subject: [PATCH 3.16 136/357] USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
Date: Fri,  3 Oct 2014 14:28:42 -0700
Message-Id: <20141003212937.554468674@linuxfoundation.org>
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

---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -101,6 +101,12 @@ UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x
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


