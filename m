Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3GKOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab3GKOZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 27/98] ALSA: hda - Cache the MUX selection for generic HDMI
Date: Thu, 11 Jul 2013 15:23:57 +0100
Message-Id: <1373552708-15235-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit bddee96b5d0db869f47b195fe48c614ca824203c upstream.

When a selection to a converter MUX is changed in hdmi_pcm_open(), it
should be cached so that the given connection can be restored properly
at PM resume.  We need just to replace the corresponding
snd_hda_codec_write() call with snd_hda_codec_write_cache().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 45e3102..2af1285 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -910,7 +910,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 	per_cvt->assigned = 1;
 	hinfo->nid = per_cvt->cvt_nid;
 
-	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
+	snd_hda_codec_write_cache(codec, per_pin->pin_nid, 0,
 			    AC_VERB_SET_CONNECT_SEL,
 			    mux_idx);
 	snd_hda_spdif_ctls_assign(codec, pin_idx, per_cvt->cvt_nid);
-- 
1.8.1.2

