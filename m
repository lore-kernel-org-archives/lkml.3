Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbbAJFld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:41:33 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:32998 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbAJFgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:43 -0500
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
Subject: [PATCH 10/25] staging: line6: Rename capability macros
Date: Fri,  9 Jan 2015 23:35:56 -0600
Message-Id: <1420868171-2031-11-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including "BIT" in the macro name is pointless.  Replace with "CAP" to
provide some context for what its value represents.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c   |  8 ++++----
 drivers/staging/line6/midi.c     |  2 +-
 drivers/staging/line6/pcm.c      |  2 +-
 drivers/staging/line6/playback.c |  2 +-
 drivers/staging/line6/pod.c      |  2 +-
 drivers/staging/line6/usbdefs.h  | 12 ++++++------
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index acde205..4ec87a3 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -59,7 +59,7 @@ MODULE_DEVICE_TABLE(usb, line6_id_table);
 
 #define L6PROP(dev_id, dev_name, dev_cap)\
 	{.id = dev_id,\
-	 .name = dev_name, .capabilities = LINE6_BIT_##dev_cap}
+	 .name = dev_name, .capabilities = LINE6_CAP_##dev_cap}
 
 static const struct line6_properties line6_properties_table[] = {
 	L6PROP("BassPODxt",     "BassPODxt",        CTRL_PCM_HW),
@@ -830,7 +830,7 @@ static int line6_probe(struct usb_interface *interface,
 
 	usb_set_intfdata(interface, line6);
 
-	if (properties->capabilities & LINE6_BIT_CONTROL) {
+	if (properties->capabilities & LINE6_CAP_CONTROL) {
 		/* initialize USB buffers: */
 		line6->buffer_listen =
 		    kmalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
@@ -1052,7 +1052,7 @@ static int line6_suspend(struct usb_interface *interface, pm_message_t message)
 
 	snd_power_change_state(line6->card, SNDRV_CTL_POWER_D3hot);
 
-	if (line6->properties->capabilities & LINE6_BIT_CONTROL)
+	if (line6->properties->capabilities & LINE6_CAP_CONTROL)
 		line6_stop_listen(line6);
 
 	if (line6pcm != NULL) {
@@ -1071,7 +1071,7 @@ static int line6_resume(struct usb_interface *interface)
 {
 	struct usb_line6 *line6 = usb_get_intfdata(interface);
 
-	if (line6->properties->capabilities & LINE6_BIT_CONTROL)
+	if (line6->properties->capabilities & LINE6_CAP_CONTROL)
 		line6_start_listen(line6);
 
 	snd_power_change_state(line6->card, SNDRV_CTL_POWER_D0);
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 1ac343b..c453485 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -279,7 +279,7 @@ int line6_init_midi(struct usb_line6 *line6)
 	int err;
 	struct snd_line6_midi *line6midi;
 
-	if (!(line6->properties->capabilities & LINE6_BIT_CONTROL)) {
+	if (!(line6->properties->capabilities & LINE6_CAP_CONTROL)) {
 		/* skip MIDI initialization and report success */
 		return 0;
 	}
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 86c7bcb..e09772f 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -424,7 +424,7 @@ int line6_init_pcm(struct usb_line6 *line6,
 	int ep_read = 0, ep_write = 0;
 	struct snd_line6_pcm *line6pcm;
 
-	if (!(line6->properties->capabilities & LINE6_BIT_PCM))
+	if (!(line6->properties->capabilities & LINE6_CAP_PCM))
 		return 0;	/* skip PCM initialization and report success */
 
 	/* initialize PCM subsystem based on device: */
diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index 2ca8900..54b7f60 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -261,7 +261,7 @@ static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
 #endif
 			if (!
 			    (line6pcm->line6->
-			     properties->capabilities & LINE6_BIT_HWMON)
+			     properties->capabilities & LINE6_CAP_HWMON)
 			    && (line6pcm->flags & LINE6_BITS_PLAYBACK_STREAM)
 			    && (line6pcm->flags & LINE6_BITS_CAPTURE_STREAM))
 				add_monitor_signal(urb_out, line6pcm->prev_fbuf,
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 7b4ec92f..0fb1788 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -396,7 +396,7 @@ static int pod_try_init(struct usb_interface *interface,
 	   handler.
 	 */
 
-	if (pod->line6.properties->capabilities & LINE6_BIT_CONTROL) {
+	if (pod->line6.properties->capabilities & LINE6_CAP_CONTROL) {
 		pod->monitor_level = POD_SYSTEM_INVALID;
 
 		/* initiate startup procedure: */
diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index c897dba..d6e46ee 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -15,15 +15,15 @@
 #define USB_INTERVALS_PER_SECOND 1000
 
 /* device supports settings parameter via USB */
-#define LINE6_BIT_CONTROL (1 << 0)
+#define LINE6_CAP_CONTROL (1 << 0)
 /* device supports PCM input/output via USB */
-#define LINE6_BIT_PCM (1 << 1)
+#define LINE6_CAP_PCM (1 << 1)
 /* device support hardware monitoring */
-#define LINE6_BIT_HWMON (1 << 2)
+#define LINE6_CAP_HWMON (1 << 2)
 
-#define LINE6_BIT_CTRL_PCM_HW	(LINE6_BIT_CONTROL |	\
-					 LINE6_BIT_PCM |	\
-					 LINE6_BIT_HWMON)
+#define LINE6_CAP_CTRL_PCM_HW	(LINE6_CAP_CONTROL |	\
+					 LINE6_CAP_PCM |	\
+					 LINE6_CAP_HWMON)
 
 #define LINE6_FALLBACK_INTERVAL 10
 #define LINE6_FALLBACK_MAXPACKETSIZE 16
-- 
2.1.0

