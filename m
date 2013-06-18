Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3FRC1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:27:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3FRC1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:27:06 -0400
Date: Mon, 17 Jun 2013 22:26:57 -0400
Message-Id: <201306180226.r5I2Qvsk010871@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/7] sound/usb/misc/ua101.c: convert __list_for_each usage to list_for_each
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>
---
 sound/usb/misc/ua101.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 6ad617b..8b5d2c5 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -1349,7 +1349,7 @@ static void ua101_disconnect(struct usb_interface *interface)
 	snd_card_disconnect(ua->card);
 
 	/* make sure that there are no pending USB requests */
-	__list_for_each(midi, &ua->midi_list)
+	list_for_each(midi, &ua->midi_list)
 		snd_usbmidi_disconnect(midi);
 	abort_alsa_playback(ua);
 	abort_alsa_capture(ua);
-- 
1.8.1.4

