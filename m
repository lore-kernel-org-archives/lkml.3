Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaGBKKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:10:50 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50930 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbaGBKKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:10:48 -0400
Message-ID: <1404295845.12021.29.camel@x220>
Subject: [PATCH v2] Documentation: sysfs-bus-usb: update power/persist
 description
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-api@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Jul 2014 12:10:45 +0200
In-Reply-To: <Pine.LNX.4.44L0.1406241316550.888-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406241316550.888-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2014 10:10:46.0378 (UTC) FILETIME=[E412C4A0:01CF95DD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no power/persist file for hubs. And CONFIG_USB_PERSIST was
removed in v2.6.26. Update the description of power/persist accordingly.
Also remove the line on its default value. It is not entirely correct, as
CONFIG_USB_DEFAULT_PERSIST and the USB_QUIRK_RESET flag influence the
default. It is not needed to understand this file anyhow.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v2: incorporate Alan's feedback. The clearest way to do that was to not
mention the default value at all. Trying to do handle the default
correctly made the text way too complicated. I hope Alan agrees.

Perhaps the line on hubs should not be added, as the text now states
that device directories "can" contain this file.

 Documentation/ABI/stable/sysfs-bus-usb | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-bus-usb b/Documentation/ABI/stable/sysfs-bus-usb
index a6b685724740..e2bc700a6f9c 100644
--- a/Documentation/ABI/stable/sysfs-bus-usb
+++ b/Documentation/ABI/stable/sysfs-bus-usb
@@ -3,13 +3,13 @@ Date:		May 2007
 KernelVersion:	2.6.23
 Contact:	Alan Stern <stern@rowland.harvard.edu>
 Description:
-		If CONFIG_USB_PERSIST is set, then each USB device directory
-		will contain a file named power/persist.  The file holds a
-		boolean value (0 or 1) indicating whether or not the
-		"USB-Persist" facility is enabled for the device.  Since the
-		facility is inherently dangerous, it is disabled by default
-		for all devices except hubs.  For more information, see
-		Documentation/usb/persist.txt.
+		USB device directories can contain a file named power/persist.
+		The file holds a boolean value (0 or 1) indicating whether or
+		not the "USB-Persist" facility is enabled for the device.  For
+		hubs this facility is always enabled and their device
+		directories will not contain this file.
+
+		For more information, see Documentation/usb/persist.txt.
 
 What:		/sys/bus/usb/devices/.../power/autosuspend
 Date:		March 2007
-- 
1.9.3

