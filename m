Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaBGDgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 22:36:11 -0500
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41740 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBGDgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 22:36:09 -0500
From: Hsin-Yu Chao <hychao@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dylan Reid <dgreid@chromium.org>,
        Chih-Chung Chang <chihchung@chromium.org>, Xi Wang <xi.wang@gmail.com>,
        Hsin-Yu Chao <hychao@chromium.org>,
        Ian Minett <ian_minett@creativelabs.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ALSA: hda/ca0132 - Fix recording from mode id 0x8
Date: Fri,  7 Feb 2014 11:35:30 +0800
Message-Id: <1391744130-15043-2-git-send-email-hychao@chromium.org>
X-Mailer: git-send-email 1.9.0.rc1.175.g0b1dcb5
In-Reply-To: <1391744130-15043-1-git-send-email-hychao@chromium.org>
References: <1391744130-15043-1-git-send-email-hychao@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Chromebook Pixel has a microphone under the keyboard that
is attached to node id 0x8. Before this fix, recording would
always go to the main internal mic (node id 0x7).

Signed-off-by: Hsin-Yu Chao <hychao@chromium.org>
Reviewed-by: Dylan Reid <dgreid@chromium.org>
---
 sound/pci/hda/patch_ca0132.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 59104dc..d5aabce 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2770,9 +2770,7 @@ static int ca0132_capture_pcm_prepare(struct hda_pcm_stream *hinfo,
 					unsigned int format,
 					struct snd_pcm_substream *substream)
 {
-	struct ca0132_spec *spec = codec->spec;
-
-	snd_hda_codec_setup_stream(codec, spec->adcs[substream->number],
+	snd_hda_codec_setup_stream(codec, hinfo->nid,
 				   stream_tag, 0, format);
 
 	return 0;
-- 
1.9.0.rc1.175.g0b1dcb5

