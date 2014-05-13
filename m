Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbaEML5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:57:46 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36788 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760028AbaEML5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:57:38 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH] drivers: staging: line6: Add blank lines after declarations
Date: Wed, 14 May 2014 02:56:42 +0300
Message-Id: <1400025402-6265-1-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common kernel coding style.

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/line6/capture.c  |    4 ++++
 drivers/staging/line6/midi.c     |    2 ++
 drivers/staging/line6/playback.c |    5 +++++
 drivers/staging/line6/pod.c      |    5 +++++
 drivers/staging/line6/toneport.c |    2 ++
 drivers/staging/line6/variax.c   |    2 ++
 6 files changed, 20 insertions(+)

diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
index 0eda51d..14ed0d7 100644
--- a/drivers/staging/line6/capture.c
+++ b/drivers/staging/line6/capture.c
@@ -97,6 +97,7 @@ void line6_unlink_audio_in_urbs(struct snd_line6_pcm *line6pcm)
 		if (test_bit(i, &line6pcm->active_urb_in)) {
 			if (!test_and_set_bit(i, &line6pcm->unlink_urb_in)) {
 				struct urb *u = line6pcm->urb_audio_in[i];
+
 				usb_unlink_urb(u);
 			}
 		}
@@ -122,6 +123,7 @@ void line6_wait_clear_audio_in_urbs(struct snd_line6_pcm *line6pcm)
 		if (!alive)
 			break;
 		set_current_state(TASK_UNINTERRUPTIBLE);
+
 		schedule_timeout(1);
 	} while (--timeout > 0);
 	if (alive)
@@ -334,6 +336,7 @@ static int snd_line6_capture_hw_params(struct snd_pcm_substream *substream,
 static int snd_line6_capture_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
 	line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER);
 	return snd_pcm_lib_free_pages(substream);
 }
@@ -380,6 +383,7 @@ static snd_pcm_uframes_t
 snd_line6_capture_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
 	return line6pcm->pos_in_done;
 }
 
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 02345fb..1ac343b 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -183,6 +183,7 @@ static void line6_midi_output_drain(struct snd_rawmidi_substream *substream)
 	struct usb_line6 *line6 =
 	    line6_rawmidi_substream_midi(substream)->line6;
 	struct snd_line6_midi *midi = line6->line6midi;
+
 	wait_event_interruptible(midi->send_wait,
 				 midi->num_active_send_urbs == 0);
 }
@@ -260,6 +261,7 @@ static int snd_line6_new_midi(struct snd_line6_midi *line6midi)
 static int snd_line6_midi_free(struct snd_device *device)
 {
 	struct snd_line6_midi *line6midi = device->device_data;
+
 	line6_midibuf_destroy(&line6midi->midibuf_in);
 	line6_midibuf_destroy(&line6midi->midibuf_out);
 	return 0;
diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index 0f72db5..a8e64b9 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -44,6 +44,7 @@ static void change_volume(struct urb *urb_out, int volume[],
 		}
 	} else if (bytes_per_frame == 6) {
 		unsigned char *p, *buf_end;
+
 		p = (unsigned char *)urb_out->transfer_buffer;
 		buf_end = p + urb_out->transfer_buffer_length;
 
@@ -310,6 +311,7 @@ void line6_unlink_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 		if (test_bit(i, &line6pcm->active_urb_out)) {
 			if (!test_and_set_bit(i, &line6pcm->unlink_urb_out)) {
 				struct urb *u = line6pcm->urb_audio_out[i];
+
 				usb_unlink_urb(u);
 			}
 		}
@@ -389,6 +391,7 @@ static void audio_out_callback(struct urb *urb)
 
 	if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags)) {
 		struct snd_pcm_runtime *runtime = substream->runtime;
+
 		line6pcm->pos_out_done +=
 		    length / line6pcm->properties->bytes_per_frame;
 
@@ -485,6 +488,7 @@ static int snd_line6_playback_hw_params(struct snd_pcm_substream *substream,
 static int snd_line6_playback_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
 	line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER);
 	return snd_pcm_lib_free_pages(substream);
 }
@@ -539,6 +543,7 @@ static snd_pcm_uframes_t
 snd_line6_playback_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
+
 	return line6pcm->pos_out_done;
 }
 
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index f4e95a6..44f4b2f 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -197,6 +197,7 @@ static ssize_t serial_number_show(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+
 	return sprintf(buf, "%d\n", pod->serial_number);
 }
 
@@ -208,6 +209,7 @@ static ssize_t firmware_version_show(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+
 	return sprintf(buf, "%d.%02d\n", pod->firmware_version / 100,
 		       pod->firmware_version % 100);
 }
@@ -220,6 +222,7 @@ static ssize_t device_id_show(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6_pod *pod = usb_get_intfdata(interface);
+
 	return sprintf(buf, "%d\n", pod->device_id);
 }
 
@@ -243,6 +246,7 @@ static void pod_startup2(unsigned long data)
 {
 	struct usb_line6_pod *pod = (struct usb_line6_pod *)data;
 	struct usb_line6 *line6 = &pod->line6;
+
 	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_VERSIONREQ);
 
 	/* request firmware version: */
@@ -294,6 +298,7 @@ static int snd_pod_control_monitor_get(struct snd_kcontrol *kcontrol,
 {
 	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
 	struct usb_line6_pod *pod = (struct usb_line6_pod *)line6pcm->line6;
+
 	ucontrol->value.integer.value[0] = pod->monitor_level;
 	return 0;
 }
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index dcab647..6943715 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -185,6 +185,7 @@ static int snd_toneport_monitor_get(struct snd_kcontrol *kcontrol,
 				    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_line6_pcm *line6pcm = snd_kcontrol_chip(kcontrol);
+
 	ucontrol->value.integer.value[0] = line6pcm->volume_monitor;
 	return 0;
 }
@@ -263,6 +264,7 @@ static void toneport_start_pcm(unsigned long arg)
 {
 	struct usb_line6_toneport *toneport = (struct usb_line6_toneport *)arg;
 	struct usb_line6 *line6 = &toneport->line6;
+
 	line6_pcm_acquire(line6->line6pcm, LINE6_BITS_PCM_MONITOR);
 }
 
diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index bd0f694..ae2be99 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -95,6 +95,7 @@ static void variax_startup3(struct usb_line6_variax *variax)
 static void variax_startup4(unsigned long data)
 {
 	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
+
 	CHECK_STARTUP_PROGRESS(variax->startup_progress,
 			       VARIAX_STARTUP_ACTIVATE);
 
@@ -107,6 +108,7 @@ static void variax_startup4(unsigned long data)
 static void variax_startup5(unsigned long data)
 {
 	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
+
 	CHECK_STARTUP_PROGRESS(variax->startup_progress,
 			       VARIAX_STARTUP_WORKQUEUE);
 
-- 
1.7.10.4

