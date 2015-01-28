Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbbA2JFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:05:18 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44832 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759685AbbA2JFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/176] ALSA: snd-usb: re-order some quirk entries
Date: Wed, 28 Jan 2015 15:28:40 +0100
Message-Id: <735beedafa629b508b26db5f735644a99e4f7cbd.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 358b7dfa1c32dfb77ff3261d244991a7c7c6d2cb upstream.

No code change, just a cosmetic cleanup to keep entries ordered by the
device ID within a block of unique vendor IDs.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/quirks-table.h | 170 +++++++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 86 deletions(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 9fb3a593677f..c657752a420c 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -72,22 +72,21 @@
 	}
 },
 
-/* Creative/Toshiba Multimedia Center SB-0500 */
+/* Creative/E-Mu devices */
 {
-	USB_DEVICE(0x041e, 0x3048),
+	USB_DEVICE(0x041e, 0x3010),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-		.vendor_name = "Toshiba",
-		.product_name = "SB-0500",
+		.vendor_name = "Creative Labs",
+		.product_name = "Sound Blaster MP3+",
 		.ifnum = QUIRK_NO_INTERFACE
 	}
 },
-
-/* Creative/E-Mu devices */
+/* Creative/Toshiba Multimedia Center SB-0500 */
 {
-	USB_DEVICE(0x041e, 0x3010),
+	USB_DEVICE(0x041e, 0x3048),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-		.vendor_name = "Creative Labs",
-		.product_name = "Sound Blaster MP3+",
+		.vendor_name = "Toshiba",
+		.product_name = "SB-0500",
 		.ifnum = QUIRK_NO_INTERFACE
 	}
 },
@@ -2580,17 +2579,17 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
-	USB_DEVICE(0x1235, 0x0018),
-	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-		.vendor_name = "Novation",
-		.product_name = "Twitch",
+	USB_DEVICE(0x1235, 0x0010),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Focusrite",
+		.product_name = "Saffire 6 USB",
 		.ifnum = QUIRK_ANY_INTERFACE,
 		.type = QUIRK_COMPOSITE,
 		.data = (const struct snd_usb_audio_quirk[]) {
 			{
 				.ifnum = 0,
 				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
-				.data = & (const struct audioformat) {
+				.data = &(const struct audioformat) {
 					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
 					.channels = 4,
 					.iface = 0,
@@ -2620,26 +2619,17 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
-	USB_DEVICE_VENDOR_SPEC(0x1235, 0x4661),
+	USB_DEVICE(0x1235, 0x0018),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		.vendor_name = "Novation",
-		.product_name = "ReMOTE25",
-		.ifnum = 0,
-		.type = QUIRK_MIDI_NOVATION
-	}
-},
-{
-	USB_DEVICE(0x1235, 0x0010),
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Focusrite",
-		.product_name = "Saffire 6 USB",
+		.product_name = "Twitch",
 		.ifnum = QUIRK_ANY_INTERFACE,
 		.type = QUIRK_COMPOSITE,
 		.data = (const struct snd_usb_audio_quirk[]) {
 			{
 				.ifnum = 0,
 				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
-				.data = &(const struct audioformat) {
+				.data = & (const struct audioformat) {
 					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
 					.channels = 4,
 					.iface = 0,
@@ -2668,6 +2658,66 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	USB_DEVICE_VENDOR_SPEC(0x1235, 0x4661),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.vendor_name = "Novation",
+		.product_name = "ReMOTE25",
+		.ifnum = 0,
+		.type = QUIRK_MIDI_NOVATION
+	}
+},
+{
+	/*
+	 * Focusrite Scarlett 18i6
+	 *
+	 * Avoid mixer creation, which otherwise fails because some of
+	 * the interface descriptor subtypes for interface 0 are
+	 * unknown.  That should be fixed or worked-around but this at
+	 * least allows the device to be used successfully with a DAW
+	 * and an external mixer.  See comments below about other
+	 * ignored interfaces.
+	 */
+	USB_DEVICE(0x1235, 0x8004),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.vendor_name = "Focusrite",
+		.product_name = "Scarlett 18i6",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = & (const struct snd_usb_audio_quirk[]) {
+			{
+				/* InterfaceSubClass 1 (Control Device) */
+				.ifnum = 0,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				/* InterfaceSubClass 1 (Control Device) */
+				.ifnum = 3,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = 4,
+				.type = QUIRK_MIDI_STANDARD_INTERFACE
+			},
+			{
+				/* InterfaceSubClass 1 (Device Firmware Update) */
+				.ifnum = 5,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 /* Access Music devices */
 {
@@ -2770,7 +2820,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7240),
+	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7210),
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
 		       USB_DEVICE_ID_MATCH_INT_CLASS |
 		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
@@ -2778,13 +2828,13 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		.vendor_name = "Hauppauge",
-		.product_name = "HVR-850",
+		.product_name = "HVR-950Q",
 		.ifnum = QUIRK_ANY_INTERFACE,
 		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
 	}
 },
 {
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7210),
+	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7217),
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
 		       USB_DEVICE_ID_MATCH_INT_CLASS |
 		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
@@ -2798,7 +2848,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7217),
+	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721b),
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
 		       USB_DEVICE_ID_MATCH_INT_CLASS |
 		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
@@ -2812,7 +2862,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721b),
+	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721e),
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
 		       USB_DEVICE_ID_MATCH_INT_CLASS |
 		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
@@ -2826,7 +2876,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721e),
+	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721f),
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
 		       USB_DEVICE_ID_MATCH_INT_CLASS |
 		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
@@ -2840,7 +2890,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721f),
+	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7240),
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
 		       USB_DEVICE_ID_MATCH_INT_CLASS |
 		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
@@ -2848,7 +2898,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
+		.product_name = "HVR-850",
 		.ifnum = QUIRK_ANY_INTERFACE,
 		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
 	}
@@ -3153,58 +3203,6 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 
 {
 	/*
-	 * Focusrite Scarlett 18i6
-	 *
-	 * Avoid mixer creation, which otherwise fails because some of
-	 * the interface descriptor subtypes for interface 0 are
-	 * unknown.  That should be fixed or worked-around but this at
-	 * least allows the device to be used successfully with a DAW
-	 * and an external mixer.  See comments below about other
-	 * ignored interfaces.
-	 */
-	USB_DEVICE(0x1235, 0x8004),
-	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-		.vendor_name = "Focusrite",
-		.product_name = "Scarlett 18i6",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_COMPOSITE,
-		.data = & (const struct snd_usb_audio_quirk[]) {
-			{
-				/* InterfaceSubClass 1 (Control Device) */
-				.ifnum = 0,
-				.type = QUIRK_IGNORE_INTERFACE
-			},
-			{
-				.ifnum = 1,
-				.type = QUIRK_AUDIO_STANDARD_INTERFACE
-			},
-			{
-				.ifnum = 2,
-				.type = QUIRK_AUDIO_STANDARD_INTERFACE
-			},
-			{
-				/* InterfaceSubClass 1 (Control Device) */
-				.ifnum = 3,
-				.type = QUIRK_IGNORE_INTERFACE
-			},
-			{
-				.ifnum = 4,
-				.type = QUIRK_MIDI_STANDARD_INTERFACE
-			},
-			{
-				/* InterfaceSubClass 1 (Device Firmware Update) */
-				.ifnum = 5,
-				.type = QUIRK_IGNORE_INTERFACE
-			},
-			{
-				.ifnum = -1
-			}
-		}
-	}
-},
-
-{
-	/*
 	 * Some USB MIDI devices don't have an audio control interface,
 	 * so we have to grab MIDI streaming interfaces here.
 	 */
-- 
2.2.2

