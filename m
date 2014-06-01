Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaFAOGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 10:06:54 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:43475 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaFAOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 10:06:53 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: ice1712: wm8776.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 16:07:45 +0200
Message-Id: <1401631665-21470-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/ice1712/wm8776.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/wm8776.c b/sound/pci/ice1712/wm8776.c
index e66c0da..52da0ff 100644
--- a/sound/pci/ice1712/wm8776.c
+++ b/sound/pci/ice1712/wm8776.c
@@ -510,7 +510,7 @@ static int snd_wm8776_ctl_get(struct snd_kcontrol *kcontrol,
 {
 	struct snd_wm8776 *wm = snd_kcontrol_chip(kcontrol);
 	int n = kcontrol->private_value;
-	u16 val1, val2;
+	u16 val1 = 0, val2 = 0;
 
 	if (wm->ctl[n].get)
 		wm->ctl[n].get(wm, &val1, &val2);
-- 
1.7.10.4

