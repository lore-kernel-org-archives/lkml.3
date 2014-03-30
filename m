Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaCaAQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:16:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36385 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Clemens Ladisch" <clemens@ladisch.de>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.511865767@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 121/200] ALSA: usb-audio: work around KEF X300A
 firmware bug
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 624aef494f86ed0c58056361c06347ad62b26806 upstream.

When the driver tries to access Function Unit 10, the KEF X300A
speakers' firmware apparently locks up, making even PCM streaming
impossible.  Work around this by ignoring this FU.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/mixer_maps.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -304,6 +304,11 @@ static struct usbmix_name_map hercules_u
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
@@ -371,6 +376,10 @@ static struct usbmix_ctl_map usbmix_ctl_
 		.map = scratch_live_map,
 		.ignore_ctl_error = 1,
 	},
+	{
+		.id = USB_ID(0x27ac, 0x1000),
+		.map = kef_x300a_map,
+	},
 	{ 0 } /* terminator */
 };
 

