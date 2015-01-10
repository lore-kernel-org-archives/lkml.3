Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbbAJFgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:31 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40620 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbbAJFg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:27 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 01/25] staging: line6: Remove `device_bit' from properties
Date: Fri,  9 Jan 2015 23:35:47 -0600
Message-Id: <1420868171-2031-2-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `device_bit' member was no longer used as of commit 2807904441d4
(staging: line6: drop MIDI parameter sysfs attrs).

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c  | 44 +++++++++++++++---------------
 drivers/staging/line6/driver.h  |  5 ----
 drivers/staging/line6/pcm.h     |  2 ++
 drivers/staging/line6/usbdefs.h | 59 -----------------------------------------
 4 files changed, 24 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 503b2d7..15f3bc4 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -57,32 +57,32 @@ static const struct usb_device_id line6_id_table[] = {
 
 MODULE_DEVICE_TABLE(usb, line6_id_table);
 
-#define L6PROP(dev_bit, dev_id, dev_name, dev_cap)\
-	{.device_bit = LINE6_BIT_##dev_bit, .id = dev_id,\
+#define L6PROP(dev_id, dev_name, dev_cap)\
+	{.id = dev_id,\
 	 .name = dev_name, .capabilities = LINE6_BIT_##dev_cap}
 
 /* *INDENT-OFF* */
 static const struct line6_properties line6_properties_table[] = {
-	L6PROP(BASSPODXT,     "BassPODxt",     "BassPODxt",        CTRL_PCM_HW),
-	L6PROP(BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   CTRL_PCM_HW),
-	L6PROP(BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    CTRL_PCM_HW),
-	L6PROP(GUITARPORT,    "GuitarPort",    "GuitarPort",       PCM),
-	L6PROP(POCKETPOD,     "PocketPOD",     "Pocket POD",       CONTROL),
-	L6PROP(PODHD300,      "PODHD300",      "POD HD300",        CTRL_PCM_HW),
-	L6PROP(PODHD400,      "PODHD400",      "POD HD400",        CTRL_PCM_HW),
-	L6PROP(PODHD500,      "PODHD500",      "POD HD500",        CTRL_PCM_HW),
-	L6PROP(PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    PCM),
-	L6PROP(PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   PCM),
-	L6PROP(PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   PCM),
-	L6PROP(PODX3,         "PODX3",         "POD X3",           PCM),
-	L6PROP(PODX3LIVE,     "PODX3Live",     "POD X3 Live",      PCM),
-	L6PROP(PODXT,         "PODxt",         "PODxt",            CTRL_PCM_HW),
-	L6PROP(PODXTLIVE,     "PODxtLive",     "PODxt Live",       CTRL_PCM_HW),
-	L6PROP(PODXTPRO,      "PODxtPro",      "PODxt Pro",        CTRL_PCM_HW),
-	L6PROP(TONEPORT_GX,   "TonePortGX",    "TonePort GX",      PCM),
-	L6PROP(TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     PCM),
-	L6PROP(TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     PCM),
-	L6PROP(VARIAX,        "Variax",        "Variax Workbench", CONTROL),
+	L6PROP("BassPODxt",     "BassPODxt",        CTRL_PCM_HW),
+	L6PROP("BassPODxtLive", "BassPODxt Live",   CTRL_PCM_HW),
+	L6PROP("BassPODxtPro",  "BassPODxt Pro",    CTRL_PCM_HW),
+	L6PROP("GuitarPort",    "GuitarPort",       PCM),
+	L6PROP("PocketPOD",     "Pocket POD",       CONTROL),
+	L6PROP("PODHD300",      "POD HD300",        CTRL_PCM_HW),
+	L6PROP("PODHD400",      "POD HD400",        CTRL_PCM_HW),
+	L6PROP("PODHD500",      "POD HD500",        CTRL_PCM_HW),
+	L6PROP("PODStudioGX",   "POD Studio GX",    PCM),
+	L6PROP("PODStudioUX1",  "POD Studio UX1",   PCM),
+	L6PROP("PODStudioUX2",  "POD Studio UX2",   PCM),
+	L6PROP("PODX3",         "POD X3",           PCM),
+	L6PROP("PODX3Live",     "POD X3 Live",      PCM),
+	L6PROP("PODxt",         "PODxt",            CTRL_PCM_HW),
+	L6PROP("PODxtLive",     "PODxt Live",       CTRL_PCM_HW),
+	L6PROP("PODxtPro",      "PODxt Pro",        CTRL_PCM_HW),
+	L6PROP("TonePortGX",    "TonePort GX",      PCM),
+	L6PROP("TonePortUX1",   "TonePort UX1",     PCM),
+	L6PROP("TonePortUX2",   "TonePort UX2",     PCM),
+	L6PROP("Variax",        "Variax Workbench", CONTROL),
 };
 /* *INDENT-ON* */
 
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 16e3fc2..1cc7532 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -76,11 +76,6 @@ static const int SYSEX_EXTRA_SIZE = sizeof(line6_midi_id) + 4;
 */
 struct line6_properties {
 	/**
-		 Bit identifying this device in the line6usb driver.
-	*/
-	int device_bit;
-
-	/**
 		 Card id string (maximum 16 characters).
 		 This can be used to address the device in ALSA programs as
 		 "default:CARD=<id>"
diff --git a/drivers/staging/line6/pcm.h b/drivers/staging/line6/pcm.h
index 6aa0d46..5716f16 100644
--- a/drivers/staging/line6/pcm.h
+++ b/drivers/staging/line6/pcm.h
@@ -98,6 +98,8 @@ enum {
 	LINE6_INDEX_PAUSE_PLAYBACK,
 	LINE6_INDEX_PREPARED,
 
+#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
+
 	/* individual bit masks: */
 	LINE6_BIT(PCM_ALSA_PLAYBACK_BUFFER),
 	LINE6_BIT(PCM_ALSA_PLAYBACK_STREAM),
diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index 2d1cc47..2bc2fe7 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -40,65 +40,6 @@
 #define LINE6_DEVID_TONEPORT_UX2  0x4142
 #define LINE6_DEVID_VARIAX        0x534d
 
-#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
-
-enum {
-	LINE6_INDEX_BASSPODXT,
-	LINE6_INDEX_BASSPODXTLIVE,
-	LINE6_INDEX_BASSPODXTPRO,
-	LINE6_INDEX_GUITARPORT,
-	LINE6_INDEX_POCKETPOD,
-	LINE6_INDEX_PODHD300,
-	LINE6_INDEX_PODHD400,
-	LINE6_INDEX_PODHD500,
-	LINE6_INDEX_PODSTUDIO_GX,
-	LINE6_INDEX_PODSTUDIO_UX1,
-	LINE6_INDEX_PODSTUDIO_UX2,
-	LINE6_INDEX_PODX3,
-	LINE6_INDEX_PODX3LIVE,
-	LINE6_INDEX_PODXT,
-	LINE6_INDEX_PODXTLIVE,
-	LINE6_INDEX_PODXTPRO,
-	LINE6_INDEX_TONEPORT_GX,
-	LINE6_INDEX_TONEPORT_UX1,
-	LINE6_INDEX_TONEPORT_UX2,
-	LINE6_INDEX_VARIAX,
-
-	LINE6_BIT(BASSPODXT),
-	LINE6_BIT(BASSPODXTLIVE),
-	LINE6_BIT(BASSPODXTPRO),
-	LINE6_BIT(GUITARPORT),
-	LINE6_BIT(POCKETPOD),
-	LINE6_BIT(PODHD300),
-	LINE6_BIT(PODHD400),
-	LINE6_BIT(PODHD500),
-	LINE6_BIT(PODSTUDIO_GX),
-	LINE6_BIT(PODSTUDIO_UX1),
-	LINE6_BIT(PODSTUDIO_UX2),
-	LINE6_BIT(PODX3),
-	LINE6_BIT(PODX3LIVE),
-	LINE6_BIT(PODXT),
-	LINE6_BIT(PODXTLIVE),
-	LINE6_BIT(PODXTPRO),
-	LINE6_BIT(TONEPORT_GX),
-	LINE6_BIT(TONEPORT_UX1),
-	LINE6_BIT(TONEPORT_UX2),
-	LINE6_BIT(VARIAX),
-
-	LINE6_BITS_PRO = LINE6_BIT_BASSPODXTPRO | LINE6_BIT_PODXTPRO,
-	LINE6_BITS_LIVE = LINE6_BIT_BASSPODXTLIVE | LINE6_BIT_PODXTLIVE |
-			  LINE6_BIT_PODX3LIVE,
-	LINE6_BITS_PODXTALL = LINE6_BIT_PODXT | LINE6_BIT_PODXTLIVE |
-			      LINE6_BIT_PODXTPRO,
-	LINE6_BITS_PODX3ALL = LINE6_BIT_PODX3 | LINE6_BIT_PODX3LIVE,
-	LINE6_BITS_PODHDALL = LINE6_BIT_PODHD300 |
-			      LINE6_BIT_PODHD400 |
-			      LINE6_BIT_PODHD500,
-	LINE6_BITS_BASSPODXTALL	= LINE6_BIT_BASSPODXT |
-				  LINE6_BIT_BASSPODXTLIVE |
-				  LINE6_BIT_BASSPODXTPRO
-};
-
 /* device supports settings parameter via USB */
 #define LINE6_BIT_CONTROL (1 << 0)
 /* device supports PCM input/output via USB */
-- 
2.1.0

