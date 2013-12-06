Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162250Ab3LFNGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:06:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162217Ab3LFNGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:06:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 268/272] ALSA: hda - Don't turn off EAPD for headphone on Lenovo N100
Date: Fri,  6 Dec 2013 12:59:17 +0000
Message-Id: <1386334761-25517-269-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7a3e6107f94344e65c35bfe62de6c096a7b48965 upstream.

The only EAPD on AD1986A is on NID 0x1b where usually the speaker.
But this doesn't control only the speaker amp but may influence on all
outputs, e.g. Lenovo N100 laptop seems to have this issue.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index d97f0d6..e17b55a 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1197,8 +1197,12 @@ static int alloc_ad_spec(struct hda_codec *codec)
 static void ad_fixup_inv_jack_detect(struct hda_codec *codec,
 				     const struct hda_fixup *fix, int action)
 {
-	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+	struct ad198x_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		codec->inv_jack_detect = 1;
+		spec->gen.keep_eapd_on = 1;
+	}
 }
 
 enum {
-- 
1.8.3.2

