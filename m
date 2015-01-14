Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbbANIeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:34:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbbANH1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Jaburek <jjaburek@redhat.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.18 074/150] ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC
Date: Tue, 13 Jan 2015 23:22:25 -0800
Message-Id: <20150114072059.196105673@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Jaburek <jjaburek@redhat.com>

commit d70a1b9893f820fdbcdffac408c909c50f2e6b43 upstream.

The Arcam rPAC seems to have the same problem - whenever anything
(alsamixer, udevd, 3.9+ kernel from 60af3d037eb8c, ..) attempts to
access mixer / control interface of the card, the firmware "locks up"
the entire device, resulting in
  SNDRV_PCM_IOCTL_HW_PARAMS failed (-5): Input/output error
from alsa-lib.

Other operating systems can somehow read the mixer (there seems to be
playback volume/mute), but any manipulation is ignored by the device
(which has hardware volume controls).

Signed-off-by: Jiri Jaburek <jjaburek@redhat.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_maps.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -328,8 +328,11 @@ static struct usbmix_name_map gamecom780
 	{}
 };
 
-static const struct usbmix_name_map kef_x300a_map[] = {
-	{ 10, NULL }, /* firmware locks up (?) when we try to access this FU */
+/* some (all?) SCMS USB3318 devices are affected by a firmware lock up
+ * when anything attempts to access FU 10 (control)
+ */
+static const struct usbmix_name_map scms_usb3318_map[] = {
+	{ 10, NULL },
 	{ 0 }
 };
 
@@ -425,8 +428,14 @@ static struct usbmix_ctl_map usbmix_ctl_
 		.map = ebox44_map,
 	},
 	{
+		/* KEF X300A */
 		.id = USB_ID(0x27ac, 0x1000),
-		.map = kef_x300a_map,
+		.map = scms_usb3318_map,
+	},
+	{
+		/* Arcam rPAC */
+		.id = USB_ID(0x25c4, 0x0003),
+		.map = scms_usb3318_map,
 	},
 	{ 0 } /* terminator */
 };


