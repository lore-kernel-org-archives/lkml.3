Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641Ab3B1PVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:21:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3B1Oqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 019/139] ALSA: usb-audio: fix Roland A-PRO support
Date: Thu, 28 Feb 2013 14:42:49 +0000
Message-Id: <1362062689-2567-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 7da58046482fceb17c4a0d4afefd9507ec56de7f upstream.

The quirk for the Roland/Cakewalk A-PRO keyboards accidentally used the
wrong interface number, which prevented the driver from attaching to the
device.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/quirks-table.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index d73ac9b..128eb0c 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1658,7 +1658,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		/* .vendor_name = "Roland", */
 		/* .product_name = "A-PRO", */
-		.ifnum = 1,
+		.ifnum = 0,
 		.type = QUIRK_MIDI_FIXED_ENDPOINT,
 		.data = & (const struct snd_usb_midi_endpoint_info) {
 			.out_cables = 0x0003,
-- 
1.8.1.2

