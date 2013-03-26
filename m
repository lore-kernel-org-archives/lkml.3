Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab3CZXRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:17:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3CZWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: [ 52/72] usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player
Date: Tue, 26 Mar 2013 15:51:35 -0700
Message-Id: <20130326224925.051271993@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Artamonow <mad_soft@inbox.ru>

commit 29f86e66428ee083aec106cca1748dc63d98ce23 upstream.

Device stucks on filesystem writes, unless following quirk is passed:
  echo 04e8:5136:m > /sys/module/usb_storage/parameters/quirks

Add corresponding entry to unusual_devs.h

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


