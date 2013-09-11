Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab3IKG4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:56:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3IKG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:56:45 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=tHPrM6QJN2YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_1cj-26_j5gA:10 a=P9AO8p_xAAAA:8 a=y3olD_i8AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=erSWKhhUCcwA:10 a=Kwnw7xPQmcgA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042905.177937111@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ren Bigcren <bigcren.ren@sonymobile.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Oskar Andero <oskar.andero@sonymobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [077/251] USB: storage: Add MicroVault Flash Drive to unusual_devs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0077-USB-storage-Add-MicroVault-Flash-Drive-to-unusual_de.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ren Bigcren <bigcren.ren@sonymobile.com>

[ Upstream commit e7a6121f4929c17215f0cdca3726f4bf3e4e9529 ]

The device report an error capacity when read_capacity_16().
Using read_capacity_10() can get the correct capacity.

Signed-off-by: Ren Bigcren <bigcren.ren@sonymobile.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 3561322..a9e9a96 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -657,6 +657,13 @@ UNUSUAL_DEV(  0x054c, 0x016a, 0x0000, 0x9999,
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
1.7.10.4


