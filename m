Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbbAKP2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:28:36 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:49627 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbAKP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:28:35 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: ice1712: wm8766: Remove some unused functions
Date: Sun, 11 Jan 2015 16:31:40 +0100
Message-Id: <1420990300-19672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
snd_wm8766_set_power() snd_wm8766_set_master_mode()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/ice1712/wm8766.c |   16 ----------------
 sound/pci/ice1712/wm8766.h |    2 --
 2 files changed, 18 deletions(-)

diff --git a/sound/pci/ice1712/wm8766.c b/sound/pci/ice1712/wm8766.c
index 21b373b..f7ac8d5 100644
--- a/sound/pci/ice1712/wm8766.c
+++ b/sound/pci/ice1712/wm8766.c
@@ -183,22 +183,6 @@ void snd_wm8766_set_if(struct snd_wm8766 *wm, u16 dac)
 	snd_wm8766_write(wm, WM8766_REG_IFCTRL, val | dac);
 }
 
-void snd_wm8766_set_master_mode(struct snd_wm8766 *wm, u16 mode)
-{
-	u16 val = wm->regs[WM8766_REG_DACCTRL3] & ~WM8766_DAC3_MSTR_MASK;
-
-	mode &= WM8766_DAC3_MSTR_MASK;
-	snd_wm8766_write(wm, WM8766_REG_DACCTRL3, val | mode);
-}
-
-void snd_wm8766_set_power(struct snd_wm8766 *wm, u16 power)
-{
-	u16 val = wm->regs[WM8766_REG_DACCTRL3] & ~WM8766_DAC3_POWER_MASK;
-
-	power &= WM8766_DAC3_POWER_MASK;
-	snd_wm8766_write(wm, WM8766_REG_DACCTRL3, val | power);
-}
-
 void snd_wm8766_volume_restore(struct snd_wm8766 *wm)
 {
 	u16 val = wm->regs[WM8766_REG_DACR1];
diff --git a/sound/pci/ice1712/wm8766.h b/sound/pci/ice1712/wm8766.h
index c119f84..18c8d9d 100644
--- a/sound/pci/ice1712/wm8766.h
+++ b/sound/pci/ice1712/wm8766.h
@@ -155,8 +155,6 @@ struct snd_wm8766 {
 void snd_wm8766_init(struct snd_wm8766 *wm);
 void snd_wm8766_resume(struct snd_wm8766 *wm);
 void snd_wm8766_set_if(struct snd_wm8766 *wm, u16 dac);
-void snd_wm8766_set_master_mode(struct snd_wm8766 *wm, u16 mode);
-void snd_wm8766_set_power(struct snd_wm8766 *wm, u16 power);
 void snd_wm8766_volume_restore(struct snd_wm8766 *wm);
 int snd_wm8766_build_controls(struct snd_wm8766 *wm);
 
-- 
1.7.10.4

