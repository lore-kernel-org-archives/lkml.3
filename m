Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaLQWKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:10:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQWKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:10:08 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
To: alsa-devel@vger.kernel.org
Cc: Chris J Arges <chris.j.arges@canonical.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: usb-audio: Fix Scarlett 6i6 initialization typo
Date: Wed, 17 Dec 2014 16:09:35 -0600
Message-Id: <1418854194-13837-1-git-send-email-chris.j.arges@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The num_controls field was incorrectly set to 0 causing 6i6 to not be
initialized. Set this to 9.

Reported-and-tested-by: Mark Roberts <sunifiram@gmail.com>
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 sound/usb/mixer_scarlett.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett.c b/sound/usb/mixer_scarlett.c
index 9109652..7438e7c 100644
--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -655,7 +655,7 @@ static struct scarlett_device_info s6i6_info = {
 		.names = NULL
 	},
 
-	.num_controls = 0,
+	.num_controls = 9,
 	.controls = {
 		{ .num = 0, .type = SCARLETT_OUTPUTS, .name = "Monitor" },
 		{ .num = 1, .type = SCARLETT_OUTPUTS, .name = "Headphone" },
-- 
1.9.1

