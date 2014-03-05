Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbaCEPQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:16:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbaCEOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hsin-Yu Chao <hychao@chromium.org>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 060/131] ALSA: hda/ca0132 - Fix recording from mode id 0x8
Date: Wed,  5 Mar 2014 14:23:04 +0000
Message-Id: <1394029455-23128-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yu Chao <hychao@chromium.org>

commit 13c12dbe3a2ce17227f7ddef652b6a53c78fa51f upstream.

Incorrect ADC is picked in ca0132_capture_pcm_prepare(),
where it assumes multiple streams while there is one stream
per ADC. Note that ca0132_capture_pcm_cleanup() already does
the right thing.

The Chromebook Pixel has a microphone under the keyboard that
is attached to node id 0x8. Before this fix, recording would
always go to the main internal mic (node id 0x7).

Signed-off-by: Hsin-Yu Chao <hychao@chromium.org>
Reviewed-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_ca0132.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 1e1e4b2..a91ad74 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2768,9 +2768,7 @@ static int ca0132_capture_pcm_prepare(struct hda_pcm_stream *hinfo,
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
1.9.0

