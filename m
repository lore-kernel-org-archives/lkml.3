Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296Ab3B0BJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:09:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149Ab3BZX5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [ 050/150] ALSA: usb-audio: fix Roland A-PRO support
Date: Tue, 26 Feb 2013 15:55:07 -0800
Message-Id: <20130226235529.371148172@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 7da58046482fceb17c4a0d4afefd9507ec56de7f upstream.

The quirk for the Roland/Cakewalk A-PRO keyboards accidentally used the
wrong interface number, which prevented the driver from attaching to the
device.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1750,7 +1750,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		/* .vendor_name = "Roland", */
 		/* .product_name = "A-PRO", */
-		.ifnum = 1,
+		.ifnum = 0,
 		.type = QUIRK_MIDI_FIXED_ENDPOINT,
 		.data = & (const struct snd_usb_midi_endpoint_info) {
 			.out_cables = 0x0003,


