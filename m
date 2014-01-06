Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbaAFWiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614AbaAFWiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        JongHo Kim <furmuwon@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 017/144] ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function
Date: Mon,  6 Jan 2014 14:36:18 -0800
Message-Id: <20140106223745.821586357@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JongHo Kim <furmuwon@gmail.com>

commit ed697e1aaf7237b1a62af39f64463b05c262808d upstream.

When the process is sleeping at the SNDRV_PCM_STATE_PAUSED
state from the wait_for_avail function, the sleep process will be woken by
timeout(10 seconds). Even if the sleep process wake up by timeout, by this
patch, the process will continue with sleep and wait for the other state.

Signed-off-by: JongHo Kim <furmuwon@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_lib.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1937,6 +1937,8 @@ static int wait_for_avail(struct snd_pcm
 		case SNDRV_PCM_STATE_DISCONNECTED:
 			err = -EBADFD;
 			goto _endloop;
+		case SNDRV_PCM_STATE_PAUSED:
+			continue;
 		}
 		if (!tout) {
 			snd_printd("%s write error (DMA or IRQ trouble?)\n",


