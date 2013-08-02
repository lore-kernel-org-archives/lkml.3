Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3HBKWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:22:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3HBKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:22:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ren Bigcren <bigcren.ren@sonymobile.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [ 01/23] USB: storage: Add MicroVault Flash Drive to unusual_devs
Date: Fri,  2 Aug 2013 18:23:14 +0800
Message-Id: <20130802102036.387714099@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802102036.180660415@linuxfoundation.org>
References: <20130802102036.180660415@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ren Bigcren <bigcren.ren@sonymobile.com>

commit e7a6121f4929c17215f0cdca3726f4bf3e4e9529 upstream.

The device report an error capacity when read_capacity_16().
Using read_capacity_10() can get the correct capacity.

Signed-off-by: Ren Bigcren <bigcren.ren@sonymobile.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -657,6 +657,13 @@ UNUSUAL_DEV(  0x054c, 0x016a, 0x0000, 0x
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


