Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3CYB2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:28:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34023 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756072Ab3CYBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:04 -0400
Message-Id: <20130325010530.505948660@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dmitry Artamonow <mad_soft@inbox.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 063/104] usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Artamonow <mad_soft@inbox.ru>

commit 29f86e66428ee083aec106cca1748dc63d98ce23 upstream.

Device stucks on filesystem writes, unless following quirk is passed:
  echo 04e8:5136:m > /sys/module/usb_storage/parameters/quirks

Add corresponding entry to unusual_devs.h

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -488,6 +488,13 @@ UNUSUAL_DEV(  0x04e8, 0x5122, 0x0000, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 | US_FL_BULK_IGNORE_TAG),
 
+/* Added by Dmitry Artamonow <mad_soft@inbox.ru> */
+UNUSUAL_DEV(  0x04e8, 0x5136, 0x0000, 0x9999,
+		"Samsung",
+		"YP-Z3",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota@auburn.edu>.
  * Device uses standards-violating 32-byte Bulk Command Block Wrappers and
  * reports itself as "Proprietary SCSI Bulk." Cf. device entry 0x084d:0x0011.


