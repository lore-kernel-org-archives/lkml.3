Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab3K0Box (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:44:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab3K0A5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cyrus Lien <cyrus.lien@canonical.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 40/80] ALSA: hda - Fix Line Out automute on Realtek multifunction jacks
Date: Tue, 26 Nov 2013 16:57:09 -0800
Message-Id: <20131127005643.715387986@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3093,8 +3093,10 @@ static void alc_update_headset_mode(stru
 	else
 		new_headset_mode = ALC_HEADSET_MODE_HEADPHONE;
 
-	if (new_headset_mode == spec->current_headset_mode)
+	if (new_headset_mode == spec->current_headset_mode) {
+		snd_hda_gen_update_outputs(codec);
 		return;
+	}
 
 	switch (new_headset_mode) {
 	case ALC_HEADSET_MODE_UNPLUGGED:


