Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbbA2JEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:04:39 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44822 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752241AbbA2JEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/176] ALSA: usb-audio: Add support for Focusrite Saffire 6 USB
Date: Wed, 28 Jan 2015 15:28:39 +0100
Message-Id: <f27db99b3c5b8bb0b4216130da6178cc4221f00b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduard Gilmutdinov <edgilmutdinov@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 11e424e88bd493b5d55d73d96c82bd889002ef30 upstream.

Signed-off-by: Eduard Gilmutdinov <edgilmutdinov@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/quirks-table.h | 40 ++++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.c       |  9 +++++----
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 01fac71992ba..9fb3a593677f 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2628,6 +2628,46 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.type = QUIRK_MIDI_NOVATION
 	}
 },
+{
+	USB_DEVICE(0x1235, 0x0010),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Focusrite",
+		.product_name = "Saffire 6 USB",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 4,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = UAC_EP_CS_ATTR_SAMPLE_RATE,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC,
+					.rates = SNDRV_PCM_RATE_44100 |
+						 SNDRV_PCM_RATE_48000,
+					.rate_min = 44100,
+					.rate_max = 48000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) {
+						44100, 48000
+					}
+				}
+			},
+			{
+				.ifnum = 1,
+				.type = QUIRK_MIDI_RAW_BYTES
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 /* Access Music devices */
 {
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 3fbb4553ba40..8bea68660061 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -662,8 +662,9 @@ static int snd_usb_cm6206_boot_quirk(struct usb_device *dev)
 
 /*
  * Novation Twitch DJ controller
+ * Focusrite Novation Saffire 6 USB audio card
  */
-static int snd_usb_twitch_boot_quirk(struct usb_device *dev)
+static int snd_usb_novation_boot_quirk(struct usb_device *dev)
 {
 	/* preemptively set up the device because otherwise the
 	 * raw MIDI endpoints are not active */
@@ -972,9 +973,9 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 		/* Digidesign Mbox 2 */
 		return snd_usb_mbox2_boot_quirk(dev);
 
-	case USB_ID(0x1235, 0x0018):
-		/* Focusrite Novation Twitch */
-		return snd_usb_twitch_boot_quirk(dev);
+	case USB_ID(0x1235, 0x0010): /* Focusrite Novation Saffire 6 USB */
+	case USB_ID(0x1235, 0x0018): /* Focusrite Novation Twitch */
+		return snd_usb_novation_boot_quirk(dev);
 
 	case USB_ID(0x133e, 0x0815):
 		/* Access Music VirusTI Desktop */
-- 
2.2.2

