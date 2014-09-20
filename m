Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbaITEDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 00:03:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43379 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaITEDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 00:03:19 -0400
Date: Fri, 19 Sep 2014 21:03:15 -0700
From: Amber Thrall <amber.rose.thrall@gmail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Media: USB: usbtv: Fixed all coding style issues in usbtv
 source files.
Message-ID: <20140920040314.GA17113@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed various coding styles, ignoring coding style error on line 5 for all files containing a link that is longer than 80 characters long.

Signed-off-by: Amber Thrall <amber.rose.thrall@gmail.com>
---
 drivers/media/usb/usbtv/usbtv-audio.c | 1 +
 drivers/media/usb/usbtv/usbtv-core.c  | 1 +
 drivers/media/usb/usbtv/usbtv-video.c | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbtv/usbtv-audio.c
index 2d8795f..78c12d2 100644
--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -311,6 +311,7 @@ static int snd_usbtv_card_trigger(struct snd_pcm_substream *substream, int cmd)
 static snd_pcm_uframes_t snd_usbtv_pointer(struct snd_pcm_substream *substream)
 {
 	struct usbtv *chip = snd_pcm_substream_chip(substream);
+
 	return chip->snd_buffer_pos;
 }
 
diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index bf25ecf..29428be 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -108,6 +108,7 @@ usbtv_video_fail:
 static void usbtv_disconnect(struct usb_interface *intf)
 {
 	struct usbtv *usbtv = usb_get_intfdata(intf);
+
 	usb_set_intfdata(intf, NULL);
 
 	if (!usbtv)
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 3d6ed1f..9d3525f 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -263,6 +263,7 @@ static void usbtv_chunk_to_vbuf(u32 *frame, __be32 *src, int chunk_no, int odd)
 		int part_index = (line * 2 + !odd) * 3 + (part_no % 3);
 
 		u32 *dst = &frame[part_index * USBTV_CHUNK/2];
+
 		memcpy(dst, src, USBTV_CHUNK/2 * sizeof(*src));
 		src += USBTV_CHUNK/2;
 	}
@@ -407,6 +408,7 @@ static void usbtv_stop(struct usbtv *usbtv)
 	/* Cancel running transfers. */
 	for (i = 0; i < USBTV_ISOC_TRANSFERS; i++) {
 		struct urb *ip = usbtv->isoc_urbs[i];
+
 		if (ip == NULL)
 			continue;
 		usb_kill_urb(ip);
@@ -560,6 +562,7 @@ static int usbtv_g_input(struct file *file, void *priv, unsigned int *i)
 static int usbtv_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct usbtv *usbtv = video_drvdata(file);
+
 	return usbtv_select_input(usbtv, i);
 }
 
-- 
2.1.0
