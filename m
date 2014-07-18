Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965867AbaGRRer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:34:47 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53584 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965576AbaGRReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:34:46 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        dan.j.williams@intel.com, valentine.barshak@cogentembedded.com,
        ming.lei@canonical.com, michael.opdenacker@free-electrons.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb-core: Remove Fix mes in file hcd.c
Date: Fri, 18 Jul 2014 13:34:40 -0400
Message-Id: <1405704880-10036-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am removing two fix mes in this file as after dicussing then it  seems
there is no reason to check against Null for usb_device as it can never
be NULL and this is check is therefore not needed.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/usb/core/hcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bec31e2..487abcf 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -855,8 +855,6 @@ static ssize_t authorized_default_show(struct device *dev,
 	struct usb_bus *usb_bus = rh_usb_dev->bus;
 	struct usb_hcd *usb_hcd;
 
-	if (usb_bus == NULL)	/* FIXME: not sure if this case is possible */
-		return -ENODEV;
 	usb_hcd = bus_to_hcd(usb_bus);
 	return snprintf(buf, PAGE_SIZE, "%u\n", usb_hcd->authorized_default);
 }
@@ -871,8 +869,6 @@ static ssize_t authorized_default_store(struct device *dev,
 	struct usb_bus *usb_bus = rh_usb_dev->bus;
 	struct usb_hcd *usb_hcd;
 
-	if (usb_bus == NULL)	/* FIXME: not sure if this case is possible */
-		return -ENODEV;
 	usb_hcd = bus_to_hcd(usb_bus);
 	result = sscanf(buf, "%u\n", &val);
 	if (result == 1) {
-- 
1.9.1

