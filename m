Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaKLBch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:32:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183AbaKLBce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.17 215/319] uas: Add US_FL_NO_ATA_1X quirk for 2 more Seagate models
Date: Wed, 12 Nov 2014 10:15:53 +0900
Message-Id: <20141112011028.412862450@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit d1d9548256fbdf2e049d6413a5266c41e73658ee upstream.

These drives hang when receiving ATA12 commands, so set the US_FL_NO_ATA_1X
quirk to filter these out.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -54,6 +54,20 @@ UNUSUAL_DEV(0x0bc2, 0x3312, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV(0x0bc2, 0x3320, 0x0000, 0x9999,
+		"Seagate",
+		"Expansion Desk",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
+/* Reported-by: Bogdan Mihalcea <bogdan.mihalcea@infim.ro> */
+UNUSUAL_DEV(0x0bc2, 0xa003, 0x0000, 0x9999,
+		"Seagate",
+		"Backup Plus",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* https://bbs.archlinux.org/viewtopic.php?id=183190 */
 UNUSUAL_DEV(0x0bc2, 0xab20, 0x0000, 0x9999,
 		"Seagate",


