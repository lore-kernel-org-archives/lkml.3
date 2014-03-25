Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaCYRp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:45:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaCYRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 30/81] ALSA: usb-audio: work around KEF X300A firmware bug
Date: Tue, 25 Mar 2014 10:15:43 -0700
Message-Id: <1395767794-5012-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 624aef494f86ed0c58056361c06347ad62b26806 upstream.

When the driver tries to access Function Unit 10, the KEF X300A
speakers' firmware apparently locks up, making even PCM streaming
impossible.  Work around this by ignoring this FU.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/mixer_maps.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 65e1d7a..87db644 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -328,6 +328,11 @@ static struct usbmix_name_map gamecom780_map[] = {
 	{}
 };
 
+static const struct usbmix_name_map kef_x300a_map[] = {
+	{ 10, NULL }, /* firmware locks up (?) when we try to access this FU */
+	{ 0 }
+};
+
 /*
  * Control map entries
  */
@@ -415,6 +420,10 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
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
1.8.3.2

