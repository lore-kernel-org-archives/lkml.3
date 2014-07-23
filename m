Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaGWM4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:56:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39288 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaGWM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:56:41 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Sasha Levin <sasha.levin@oracle.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH] usb-core: Revert "usb-core: Remove Fix mes in file hcd.c"
Date: Wed, 23 Jul 2014 08:56:10 -0400
Message-Id: <1406120170-22983-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert since the commit message is incorrect and the original author refuses
to fix/maintain it because "it's in the kernel already".

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 487abcf..bec31e2 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -855,6 +855,8 @@ static ssize_t authorized_default_show(struct device *dev,
 	struct usb_bus *usb_bus = rh_usb_dev->bus;
 	struct usb_hcd *usb_hcd;
 
+	if (usb_bus == NULL)	/* FIXME: not sure if this case is possible */
+		return -ENODEV;
 	usb_hcd = bus_to_hcd(usb_bus);
 	return snprintf(buf, PAGE_SIZE, "%u\n", usb_hcd->authorized_default);
 }
@@ -869,6 +871,8 @@ static ssize_t authorized_default_store(struct device *dev,
 	struct usb_bus *usb_bus = rh_usb_dev->bus;
 	struct usb_hcd *usb_hcd;
 
+	if (usb_bus == NULL)	/* FIXME: not sure if this case is possible */
+		return -ENODEV;
 	usb_hcd = bus_to_hcd(usb_bus);
 	result = sscanf(buf, "%u\n", &val);
 	if (result == 1) {
-- 
1.9.1

