Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3LSMuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:50:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab3LSL5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 078/208] ALSA: hda - Fix bad EAPD setup for HP machines with AD1984A
Date: Thu, 19 Dec 2013 11:52:56 +0000
Message-Id: <1387454106-19326-79-git-send-email-luis.henriques@canonical.com>
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

commit 1cd9b2f78bf29d5282e02b32f9b3ecebc5842a7c upstream.

It seems that EAPD on NID 0x16 is the only control over all outputs on
HP machines with AD1984A while turning EAPD on NID 0x12 breaks the
output.  Thus we need to avoid fiddling EAPD on NID.  As a quick
workaround, just set own_eapd_ctrl flag for the wrong EAPD, then
implement finer EAPD controls.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66321
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index e17b55a..9eccfba 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3611,6 +3611,7 @@ static void ad1884_fixup_hp_eapd(struct hda_codec *codec,
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		spec->gen.vmaster_mute.hook = ad_vmaster_eapd_hook;
+		spec->gen.own_eapd_ctl = 1;
 		break;
 	case HDA_FIXUP_ACT_PROBE:
 		if (spec->gen.autocfg.line_out_type == AUTO_PIN_SPEAKER_OUT)
-- 
1.8.3.2

