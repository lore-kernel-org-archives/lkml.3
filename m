Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3FDWmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:02 -0400
Received: from 1wt.eu ([62.212.114.60]:35334 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab3FDWlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:55 -0400
Message-Id: <20130604172132.177051798@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 045/184] ALSA: ac97 - Fix missing NULL check in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 snd_ac97_cvol_new()

From: Takashi Iwai <tiwai@suse.de>

commit 733a48e5ae5bf28b046fad984d458c747cbb8c21 upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=44721

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/pci/ac97/ac97_codec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 78288db..5f295f7 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1252,6 +1252,8 @@ static int snd_ac97_cvol_new(struct snd_card *card, char *name, int reg, unsigne
 		tmp.index = ac97->num;
 		kctl = snd_ctl_new1(&tmp, ac97);
 	}
+	if (!kctl)
+		return -ENOMEM;
 	if (reg >= AC97_PHONE && reg <= AC97_PCM)
 		set_tlv_db_scale(kctl, db_scale_5bit_12db_max);
 	else
-- 
1.7.12.2.21.g234cd45.dirty



