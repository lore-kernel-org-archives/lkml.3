Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaKQKH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:07:28 -0500
Received: from mout.web.de ([212.227.15.4]:57367 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaKQKH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:07:26 -0500
Message-ID: <5469C8C8.8010306@users.sourceforge.net>
Date: Mon, 17 Nov 2014 11:07:04 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] ALSA: hda: Deletion of unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zuhLQaIjuTUS852RB1tTTn3BBXEX1MuuO3xPIcpune8ta4vSTuJ
 Rt6Bjb7nhU7GUPB6v+fSHb5uHwHnurV5ar9cf7HeGXWdUU6biHSQfaCKom2NGo0dzRIUoy2
 i88oj2hpojz3NBax6QxyvD4Ntcx6vEJGCkO9NkW2Ve31RlIyOZ0bC4p1fC6qZ7pM/LeJKNs
 odTWG+Zsfpr/Te/8Thm8A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 17 Nov 2014 10:44:33 +0100

The functions kfree() and release_firmware() test whether their argument
is NULL and then return immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/pci/hda/hda_codec.c | 3 +--
 sound/pci/hda/hda_intel.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index ec6a7d0..3fe8859 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -827,8 +827,7 @@ static void snd_hda_bus_free(struct hda_bus *bus)
 	WARN_ON(!list_empty(&bus->codec_list));
 	if (bus->workq)
 		flush_workqueue(bus->workq);
-	if (bus->unsol)
-		kfree(bus->unsol);
+	kfree(bus->unsol);
 	if (bus->ops.private_free)
 		bus->ops.private_free(bus);
 	if (bus->workq)
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 0a7f848..b4ec4e1 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1129,8 +1129,7 @@ static int azx_free(struct azx *chip)
 	pci_disable_device(chip->pci);
 	kfree(chip->azx_dev);
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
-	if (chip->fw)
-		release_firmware(chip->fw);
+	release_firmware(chip->fw);
 #endif
 	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
 		hda_display_power(false);
-- 
2.1.3


