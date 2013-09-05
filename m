Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3IEUpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:45:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab3IEU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stratos Karafotis <stratosk@semaphore.gr>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 03/36] ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=n
Date: Thu,  5 Sep 2013 13:27:32 -0700
Message-Id: <20130905202702.724364986@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2ca320e294a738c9134a71b5029de05edbfc7aad upstream.

Without the dynamic minor assignment, HDMI codec may have less PCM
instances than the number of pins, which eventually leads to Oops.

Reported-by: Stratos Karafotis <stratosk@semaphore.gr>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1715,6 +1715,9 @@ static int generic_hdmi_build_controls(s
 		struct snd_pcm_chmap *chmap;
 		struct snd_kcontrol *kctl;
 		int i;
+
+		if (!codec->pcm_info[pin_idx].pcm)
+			break;
 		err = snd_pcm_add_chmap_ctls(codec->pcm_info[pin_idx].pcm,
 					     SNDRV_PCM_STREAM_PLAYBACK,
 					     NULL, 0, pin_idx, &chmap);


