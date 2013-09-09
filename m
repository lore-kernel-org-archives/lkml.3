Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3IISwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:52:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57055 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 09/24] ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=n
Date: Mon,  9 Sep 2013 11:44:59 -0700
Message-Id: <1378752314-2416-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2ca320e294a738c9134a71b5029de05edbfc7aad upstream.

Without the dynamic minor assignment, HDMI codec may have less PCM
instances than the number of pins, which eventually leads to Oops.

Reported-by: Stratos Karafotis <stratosk@semaphore.gr>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index ad23390..5c19496 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1617,6 +1617,9 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
 		struct snd_pcm_chmap *chmap;
 		struct snd_kcontrol *kctl;
 		int i;
+
+		if (!codec->pcm_info[pin_idx].pcm)
+			break;
 		err = snd_pcm_add_chmap_ctls(codec->pcm_info[pin_idx].pcm,
 					     SNDRV_PCM_STREAM_PLAYBACK,
 					     NULL, 0, pin_idx, &chmap);
-- 
1.8.1.2

