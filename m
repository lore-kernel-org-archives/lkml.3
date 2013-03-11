Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3CKCcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:32:24 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61033 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3CKCcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:32:23 -0400
From: David Helstroom <helstroom@google.com>
To: perex@perex.cz, tiwai@suse.de
Cc: eldad@fogrefinery.com, damien@zamaudio.com, clemens@ladisch.de,
        pete.leigh@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Dave Helstroom <helstroom@google.com>
Subject: [PATCH] Add a new USB audio quirk for the NuForce UDH-100 device. Interface 1 does not exist and Interface 0 should be ignored. Before this patch, the device would not show up in /dev/snd (and dmesg showed Error -5 from the snd-alsa-usb module); after this patch, the device shows up correctly in /dev/snd and ALSA/Pulseaudio can access it.
Date: Sun, 10 Mar 2013 19:26:41 -0700
Message-Id: <1362968801-871-1-git-send-email-helstroom@google.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Helstroom <helstroom@google.com>


Signed-off-by: Dave Helstroom <helstroom@google.com>
---
 sound/usb/quirks-table.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index c39f898..62d29ca 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2795,6 +2795,38 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* NuForce devices */
+{
+	USB_DEVICE(0x16d0, 0x0631),
+		.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Nuforce",
+		.product_name = "UDH-100",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = 1,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
 /* Native Instruments MK2 series */
 {
 	/* Komplete Audio 6 */
-- 
1.8.1.3

