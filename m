Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab3GaNpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:45:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46948 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759655Ab3GaNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oskar Andero" <oskar.andero@sonymobile.com>,
        "Matthew Dharm" <mdharm-usb@one-eyed-alien.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ren Bigcren" <bigcren.ren@sonymobile.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.751223647@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [58/84] USB: storage: Add MicroVault Flash Drive to unusual_devs
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ren Bigcren <bigcren.ren@sonymobile.com>

commit e7a6121f4929c17215f0cdca3726f4bf3e4e9529 upstream.

The device report an error capacity when read_capacity_16().
Using read_capacity_10() can get the correct capacity.

Signed-off-by: Ren Bigcren <bigcren.ren@sonymobile.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
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

