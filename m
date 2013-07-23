Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669Ab3GWWsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:48:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934588Ab3GWW1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 028/103] ALSA: hda - Cache the MUX selection for generic HDMI
Date: Tue, 23 Jul 2013 15:25:39 -0700
Message-Id: <20130723220421.717206213@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit bddee96b5d0db869f47b195fe48c614ca824203c upstream.

When a selection to a converter MUX is changed in hdmi_pcm_open(), it
should be cached so that the given connection can be restored properly
at PM resume.  We need just to replace the corresponding
snd_hda_codec_write() call with snd_hda_codec_write_cache().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1146,7 +1146,7 @@ static int hdmi_pcm_open(struct hda_pcm_
 	per_cvt->assigned = 1;
 	hinfo->nid = per_cvt->cvt_nid;
 
-	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
+	snd_hda_codec_write_cache(codec, per_pin->pin_nid, 0,
 			    AC_VERB_SET_CONNECT_SEL,
 			    mux_idx);
 	snd_hda_spdif_ctls_assign(codec, pin_idx, per_cvt->cvt_nid);


