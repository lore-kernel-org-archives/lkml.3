Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3CDDmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60716 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab3CDDmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:17 -0500
Message-Id: <20130304033709.325007252@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:25 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Clemens Ladisch <clemens@ladisch.de>
Subject: [ 018/153] ALSA: usb-audio: fix Roland A-PRO support
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 7da58046482fceb17c4a0d4afefd9507ec56de7f upstream.

The quirk for the Roland/Cakewalk A-PRO keyboards accidentally used the
wrong interface number, which prevented the driver from attaching to the
device.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/quirks-table.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1624,7 +1624,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		/* .vendor_name = "Roland", */
 		/* .product_name = "A-PRO", */
-		.ifnum = 1,
+		.ifnum = 0,
 		.type = QUIRK_MIDI_FIXED_ENDPOINT,
 		.data = & (const struct snd_usb_midi_endpoint_info) {
 			.out_cables = 0x0003,


