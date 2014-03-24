Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaCXWr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 18:47:29 -0400
Received: from mail.coding4coffee.org ([5.9.171.142]:33338 "EHLO
	mail.coding4coffee.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaCXWr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:47:28 -0400
From: Fabian Mewes <architekt@coding4coffee.org>
To: joe@perches.com
Cc: gregkh@linuxfoundation.org, ashvinivaratharaj@gmail.com,
        cbajumpa@gmail.com, rashika.kheria@gmail.com, berardi.dav@gmail.com,
        monamagarwal123@gmail.com, lisa@xenapiadmin.com,
        ebru.akagunduz@gmail.com, stefanha@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabian Mewes <architekt@coding4coffee.org>
Subject: [PATCH v2] staging: line6: Add blank lines after declarations
Date: Mon, 24 Mar 2014 23:46:31 +0100
Message-Id: <1395701191-1030-1-git-send-email-architekt@coding4coffee.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395696913.13968.67.camel@joe-AO722>
References: <1395696913.13968.67.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common kernel coding style.

Signed-off-by: Fabian Mewes <architekt@coding4coffee.org>
---
applies to next-20140324
v1..v2: improve commit message as suggested by Joe

 drivers/staging/line6/driver.c   | 1 +
 drivers/staging/line6/playback.c | 5 +++++
 drivers/staging/line6/toneport.c | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 77f1b42..ef511c7 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -124,6 +124,7 @@ static int line6_send_raw_message_async_part(struct message *msg,
 static int line6_start_listen(struct usb_line6 *line6)
 {
 	int err;
+
 	usb_fill_int_urb(line6->urb_listen, line6->usbdev,
 			 usb_rcvintpipe(line6->usbdev, line6->ep_control_read),
 			 line6->buffer_listen, LINE6_BUFSIZE_LISTEN,
diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index 41869ca..0f72db5 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -34,6 +34,7 @@ static void change_volume(struct urb *urb_out, int volume[],
 
 	if (bytes_per_frame == 4) {
 		short *p, *buf_end;
+
 		p = (short *)urb_out->transfer_buffer;
 		buf_end = p + urb_out->transfer_buffer_length / sizeof(*p);
 
@@ -48,6 +49,7 @@ static void change_volume(struct urb *urb_out, int volume[],
 
 		for (; p < buf_end; p += 3) {
 			int val;
+
 			val = p[0] + (p[1] << 8) + ((signed char)p[2] << 16);
 			val = (val * volume[chn & 1]) >> 8;
 			p[0] = val;
@@ -116,6 +118,7 @@ static void add_monitor_signal(struct urb *urb_out, unsigned char *signal,
 
 	if (bytes_per_frame == 4) {
 		short *pi, *po, *buf_end;
+
 		pi = (short *)signal;
 		po = (short *)urb_out->transfer_buffer;
 		buf_end = po + urb_out->transfer_buffer_length / sizeof(*po);
@@ -171,6 +174,7 @@ static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
 
 		if (fsize == 0) {
 			int n;
+
 			line6pcm->count_out += frame_increment;
 			n = line6pcm->count_out / frame_factor;
 			line6pcm->count_out -= n * frame_factor;
@@ -207,6 +211,7 @@ static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
 			   copy the data to the temp buffer.
 			 */
 			int len;
+
 			len = runtime->buffer_size - line6pcm->pos_out;
 
 			if (len > 0) {
diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index af2e7e5..dcab647 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -213,6 +213,7 @@ static int snd_toneport_source_info(struct snd_kcontrol *kcontrol,
 				    struct snd_ctl_elem_info *uinfo)
 {
 	const int size = ARRAY_SIZE(toneport_source_info);
+
 	uinfo->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
 	uinfo->count = 1;
 	uinfo->value.enumerated.items = size;
-- 
1.9.1

