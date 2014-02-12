Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaBLIfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:35:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50116 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbaBLINy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "JongHo Kim" <furmuwon@gmail.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.78029344@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 47/79] ALSA: Add SNDRV_PCM_STATE_PAUSED case in
 wait_for_avail function
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: JongHo Kim <furmuwon@gmail.com>

commit ed697e1aaf7237b1a62af39f64463b05c262808d upstream.

When the process is sleeping at the SNDRV_PCM_STATE_PAUSED
state from the wait_for_avail function, the sleep process will be woken by
timeout(10 seconds). Even if the sleep process wake up by timeout, by this
patch, the process will continue with sleep and wait for the other state.

Signed-off-by: JongHo Kim <furmuwon@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/pcm_lib.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1846,6 +1846,8 @@ static int wait_for_avail(struct snd_pcm
 		case SNDRV_PCM_STATE_DISCONNECTED:
 			err = -EBADFD;
 			goto _endloop;
+		case SNDRV_PCM_STATE_PAUSED:
+			continue;
 		}
 		if (!tout) {
 			snd_printd("%s write error (DMA or IRQ trouble?)\n",

