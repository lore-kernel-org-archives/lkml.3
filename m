Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaDVLmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:42:25 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33658 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaDVLmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:42:23 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: tiwai@suse.de, perex@perex.cz, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] sound: core: Fix format string mismatch in seq_midi.c
Date: Tue, 22 Apr 2014 20:42:05 +0900
Message-Id: <1398166925-26412-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0.26.g779792a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in snd_seq_midisynth_register_port().
Argument type of p is unsigned int.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 sound/core/seq/seq_midi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index 3e05c55..a1fd77a 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -362,13 +362,13 @@ snd_seq_midisynth_register_port(struct snd_seq_device *dev)
 		if (! port->name[0]) {
 			if (info->name[0]) {
 				if (ports > 1)
-					snprintf(port->name, sizeof(port->name), "%s-%d", info->name, p);
+					snprintf(port->name, sizeof(port->name), "%s-%u", info->name, p);
 				else
 					snprintf(port->name, sizeof(port->name), "%s", info->name);
 			} else {
 				/* last resort */
 				if (ports > 1)
-					sprintf(port->name, "MIDI %d-%d-%d", card->number, device, p);
+					sprintf(port->name, "MIDI %d-%d-%u", card->number, device, p);
 				else
 					sprintf(port->name, "MIDI %d-%d", card->number, device);
 			}
-- 
2.0.0.rc0.26.g779792a

