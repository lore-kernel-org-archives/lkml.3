Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3L0X5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 18:57:37 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43457 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3L0X5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 18:57:35 -0500
From: Mikhail Zolotaryov <lebon@lebon.org.ua>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Cc: linux-kernel@vger.kernel.org, Mikhail Zolotaryov <lebon@lebon.org.ua>
Subject: [PATCH 1/1] USB: Nokia 502 is an unusual device
Date: Sat, 28 Dec 2013 01:56:35 +0200
Message-Id: <1388188595-22631-1-git-send-email-lebon@lebon.org.ua>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB storage operation of Nokia Asha 502 Dual SIM smartphone running Asha
Platform 1.1.1 is unreliable in respect of data consistency (i.e. transfered
files are corrupted). A similar issue is described here:
http://discussions.nokia.com/t5/Asha-and-other-Nokia-Series-30/Nokia-301-USB-transfers-and-corrupted-files/td-p/1974170

The workaround is (MAX_SECTORS_64):
   rmmod usb_storage && modprobe usb_storage quirks=0421:06aa:m

The patch adds the tested device to the unusual list permanently.

Signed-off-by: Mikhail Zolotaryov <lebon@lebon.org.ua>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index de32cfa..ad06255 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -234,6 +234,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x0370,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Patch submitted by Mikhail Zolotaryov <lebon@lebon.org.ua> */
+UNUSUAL_DEV(  0x0421, 0x06aa, 0x1110, 0x1110,
+		"Nokia",
+		"502",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 #ifdef NO_SDDR09
 UNUSUAL_DEV(  0x0436, 0x0005, 0x0100, 0x0100,
 		"Microtech",
-- 
1.8.1.2

