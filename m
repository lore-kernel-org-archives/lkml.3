Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaKFWzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:55:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59032 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaKFWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Harsha Priya <harshapriya.n@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 080/162] ALSA: ALC283 codec - Avoid pop noise on headphones during suspend/resume
Date: Thu,  6 Nov 2014 14:35:44 -0800
Message-Id: <1415313426-9622-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harsha Priya <harshapriya.n@intel.com>

commit b450b17c156e264bc44a198046d3ebaaef5a041d upstream.

This patch sets the headphones mode to default before suspending
which helps avoid the pop noise on headphones

Signed-off-by: Harsha Priya <harshapriya.n@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b2a5832..1a24b2c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2871,6 +2871,9 @@ static void alc283_shutup(struct hda_codec *codec)
 
 	alc_write_coef_idx(codec, 0x43, 0x9004);
 
+	/*depop hp during suspend*/
+	alc_write_coef_idx(codec, 0x06, 0x2100);
+
 	snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
 
-- 
1.9.1

