Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaCDU2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:28:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaCDUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hsin-Yu Chao <hychao@chromium.org>, Dylan Reid <dgreid@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 42/97] ALSA: hda/ca0132 - Fix recording from mode id 0x8
Date: Tue,  4 Mar 2014 12:03:55 -0800
Message-Id: <20140304200347.429314569@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2768,9 +2768,7 @@ static int ca0132_capture_pcm_prepare(st
 					unsigned int format,
 					struct snd_pcm_substream *substream)
 {
-	struct ca0132_spec *spec = codec->spec;
-
-	snd_hda_codec_setup_stream(codec, spec->adcs[substream->number],
+	snd_hda_codec_setup_stream(codec, hinfo->nid,
 				   stream_tag, 0, format);
 
 	return 0;


