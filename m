Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbaCEPVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:21:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaCEOZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 040/131] ALSA: usb-audio: work around KEF X300A firmware bug
Date: Wed,  5 Mar 2014 14:22:44 +0000
Message-Id: <1394029455-23128-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 624aef494f86ed0c58056361c06347ad62b26806 upstream.

When the driver tries to access Function Unit 10, the KEF X300A
speakers' firmware apparently locks up, making even PCM streaming
impossible.  Work around this by ignoring this FU.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer_maps.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index cc2dd1f..0339d46 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -322,6 +322,11 @@ static struct usbmix_name_map hercules_usb51_map[] = {
 	{ 0 }				/* terminator */
 };
 
+static const struct usbmix_name_map kef_x300a_map[] = {
+	{ 10, NULL }, /* firmware locks up (?) when we try to access this FU */
+	{ 0 }
+};
+
 /*
  * Control map entries
  */
@@ -409,6 +414,10 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x200c, 0x1018),
 		.map = ebox44_map,
 	},
+	{
+		.id = USB_ID(0x27ac, 0x1000),
+		.map = kef_x300a_map,
+	},
 	{ 0 } /* terminator */
 };
 
-- 
1.9.0

