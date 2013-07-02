Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3GBLom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:44:42 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15823 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab3GBLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:44:41 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 07:44:40 EDT
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>,
        <linux-usb@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Radovan Lekanovic <Radovan.Lekanovic@sonymobile.com>,
        Ren Bigcren <bigcren.ren@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH] USB: storage: Add MicroVault Flash Drive to unusual_devs
Date: Tue, 2 Jul 2013 13:34:30 +0200
Message-ID: <1372764870-19485-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ren Bigcren <bigcren.ren@sonymobile.com>

The device report an error capacity when read_capacity_16().
Using read_capacity_10() can get the correct capacity.

Signed-off-by: Ren Bigcren <bigcren.ren@sonymobile.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 179933528..c015f2c 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -665,6 +665,13 @@ UNUSUAL_DEV(  0x054c, 0x016a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Submitted by Ren Bigcren <bigcren.ren@sonymobile.com> */
+UNUSUAL_DEV(  0x054c, 0x02a5, 0x0100, 0x0100,
+		"Sony Corp.",
+		"MicroVault Flash Drive",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_READ_CAPACITY_16 ),
+
 /* floppy reports multiple luns */
 UNUSUAL_DEV(  0x055d, 0x2020, 0x0000, 0x0210,
 		"SAMSUNG",
-- 
1.8.1.5

