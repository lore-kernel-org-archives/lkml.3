Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbaGOVjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802AbaGOVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pierre Ossman <pierre@ossman.eu>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 173/198] ALSA: hda - hdmi: call overridden init on resume
Date: Tue, 15 Jul 2014 14:30:43 -0700
Message-Id: <1405459868-15089-174-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Ossman <pierre@ossman.eu>

commit a283368382c50345dff61525f493ea307f21ec9b upstream.

We need to call the proper init function in case it has been
overridden, as it might restore things that the generic routing
doesn't know anything about. E.g. AMD cards have special verbs
that need resetting.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=77901
Fixes: 5a61358433b1 ('ALSA: hda - hdmi: Add ATI/AMD multi-channel audio support')
Signed-off-by: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index a21a325..2f66de6 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2177,7 +2177,7 @@ static int generic_hdmi_resume(struct hda_codec *codec)
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx;
 
-	generic_hdmi_init(codec);
+	codec->patch_ops.init(codec);
 	snd_hda_codec_resume_amp(codec);
 	snd_hda_codec_resume_cache(codec);
 
-- 
1.9.1

