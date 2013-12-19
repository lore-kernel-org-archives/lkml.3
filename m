Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3LSL5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:57:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3LSL5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 081/208] ALSA: hda - Use always amps for auto-mute on AD1986A codec
Date: Thu, 19 Dec 2013 11:52:59 +0000
Message-Id: <1387454106-19326-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b3bd4fc3822a6b5883eaa556822487d87752d443 upstream.

It seems that AD1986A cannot manage the dynamic pin on/off for
auto-muting, but rather gets confused.  Since each output has own amp,
let's use it instead.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64971
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 9eccfba..a3d9143 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1248,6 +1248,9 @@ static int ad1986a_parse_auto_config(struct hda_codec *codec)
 	 */
 	spec->gen.multiout.no_share_stream = 1;
 
+	/* AD1986A can't manage the dynamic pin on/off smoothly */
+	spec->gen.auto_mute_via_amp = 1;
+
 	snd_hda_pick_fixup(codec, NULL, ad1986a_fixup_tbl, ad1986a_fixups);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
 
-- 
1.8.3.2

