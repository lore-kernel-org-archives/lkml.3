Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaKYMCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:02:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaKYKkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 026/254] uas: Add US_FL_NO_ATA_1X quirk for 2 more Seagate models
Date: Tue, 25 Nov 2014 10:36:16 +0000
Message-Id: <1416912004-5928-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit d1d9548256fbdf2e049d6413a5266c41e73658ee upstream.

These drives hang when receiving ATA12 commands, so set the US_FL_NO_ATA_1X
quirk to filter these out.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/unusual_uas.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index ea793c1f3041..2fefaf923e4a 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -54,6 +54,20 @@ UNUSUAL_DEV(0x0bc2, 0x3312, 0x0000, 0x9999,
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
-- 
2.1.0

