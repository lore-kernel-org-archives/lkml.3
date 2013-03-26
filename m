Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138Ab3CZPW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965109Ab3CZPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 074/150] usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player
Date: Tue, 26 Mar 2013 15:19:33 +0000
Message-Id: <1364311249-14454-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Artamonow <mad_soft@inbox.ru>

commit 29f86e66428ee083aec106cca1748dc63d98ce23 upstream.

Device stucks on filesystem writes, unless following quirk is passed:
  echo 04e8:5136:m > /sys/module/usb_storage/parameters/quirks

Add corresponding entry to unusual_devs.h

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index dd2c64f..8c05e41 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -488,6 +488,13 @@ UNUSUAL_DEV(  0x04e8, 0x5122, 0x0000, 0x9999,
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
-- 
1.8.1.2

