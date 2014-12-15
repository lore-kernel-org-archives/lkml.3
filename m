Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaLOOtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:49:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaLOO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 093/168] USB: uas: Add no-uas quirk for Hitachi usb-3 enclosures 4971:1012
Date: Mon, 15 Dec 2014 14:25:47 +0000
Message-Id: <1418653622-21105-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 8daee1352d51a32676b84bddcc0e3252d1caa833 upstream.

These disks have a broken uas implementation, the tag field of the status
iu-s is not set properly, so we need to fall-back to usb-storage for these.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 2fefaf923e4a..18a283d6de1c 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -103,3 +103,10 @@ UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VL711",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
+
+/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV(0x4971, 0x1012, 0x0000, 0x9999,
+		"Hitachi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
-- 
2.1.3

