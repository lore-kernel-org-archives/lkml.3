Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaBGLqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:46:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40971 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaBGLYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 34/88] ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
Date: Fri,  7 Feb 2014 11:22:31 +0000
Message-Id: <1391772205-22239-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 770bd4bf2e664939a9dacd3d26ec9ff7a3933210 upstream.

The lack of comma leads to the wrong channel for an SPDIF channel.
Unfortunately this wasn't caught by compiler because it's still a
valid expression.

Reported-by: Alexander Aristov <aristov.alexander@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/rme9652/rme9652.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index a15fc10..1b3ce88 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -285,7 +285,7 @@ static char channel_map_9636_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15,
 	/* channels 8 and 9 are S/PDIF */
-	24, 25
+	24, 25,
 	/* others don't exist */
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
-- 
1.8.3.2

