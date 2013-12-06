Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162305Ab3LFNJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:09:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162179Ab3LFNGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:06:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 262/272] ALSA: hda - Fix Line Out automute on Realtek multifunction jacks
Date: Fri,  6 Dec 2013 12:59:11 +0000
Message-Id: <1386334761-25517-263-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 5959a6bc1124211a359525d209005abc07b0197b upstream.

In case there is both a multifunction headset jack and a Line Out
jack, automuting was not working properly from the Line Out jack.
This patch fixes that issue.

BugLink: https://bugs.launchpad.net/bugs/1250377
Tested-by: Cyrus Lien <cyrus.lien@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a67015a..69d784f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3231,8 +3231,10 @@ static void alc_update_headset_mode(struct hda_codec *codec)
 	else
 		new_headset_mode = ALC_HEADSET_MODE_HEADPHONE;
 
-	if (new_headset_mode == spec->current_headset_mode)
+	if (new_headset_mode == spec->current_headset_mode) {
+		snd_hda_gen_update_outputs(codec);
 		return;
+	}
 
 	switch (new_headset_mode) {
 	case ALC_HEADSET_MODE_UNPLUGGED:
-- 
1.8.3.2

