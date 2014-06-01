Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbaFAOB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 10:01:59 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41643 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaFAOB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 10:01:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: ice1712: wm8766.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 16:02:51 +0200
Message-Id: <1401631371-21145-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/ice1712/wm8766.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/wm8766.c b/sound/pci/ice1712/wm8766.c
index 21b373b..788a31c 100644
--- a/sound/pci/ice1712/wm8766.c
+++ b/sound/pci/ice1712/wm8766.c
@@ -237,7 +237,7 @@ static int snd_wm8766_ctl_get(struct snd_kcontrol *kcontrol,
 {
 	struct snd_wm8766 *wm = snd_kcontrol_chip(kcontrol);
 	int n = kcontrol->private_value;
-	u16 val1, val2;
+	u16 val1 = 0, val2 = 0;
 
 	if (wm->ctl[n].get)
 		wm->ctl[n].get(wm, &val1, &val2);
-- 
1.7.10.4

