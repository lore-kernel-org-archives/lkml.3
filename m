Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3GXOdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:33:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45720 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105Ab3GXOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.756748076@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [24/85] ALSA: hda - Cache the MUX selection for generic HDMI
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit bddee96b5d0db869f47b195fe48c614ca824203c upstream.

When a selection to a converter MUX is changed in hdmi_pcm_open(), it
should be cached so that the given connection can be restored properly
at PM resume.  We need just to replace the corresponding
snd_hda_codec_write() call with snd_hda_codec_write_cache().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -902,7 +902,7 @@ static int hdmi_pcm_open(struct hda_pcm_
 	per_cvt->assigned = 1;
 	hinfo->nid = per_cvt->cvt_nid;
 
-	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
+	snd_hda_codec_write_cache(codec, per_pin->pin_nid, 0,
 			    AC_VERB_SET_CONNECT_SEL,
 			    mux_idx);
 	snd_hda_spdif_ctls_assign(codec, pin_idx, per_cvt->cvt_nid);

