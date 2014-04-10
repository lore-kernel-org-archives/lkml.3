Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965432AbaDJEOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:14:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934714AbaDJDWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 054/134] Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat codecs"
Date: Wed,  9 Apr 2014 20:22:50 -0700
Message-Id: <20140410032307.104456671@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 7ed4165e2d01bdbbb4c1086eb73eadf0f64cbbf0 upstream.

This reverts commit 697c373e34613609cb5450f98b91fefb6e910588.

The original patch was meant to remove clicking, but in fact caused even
more clicking instead.

Thanks to c4pp4 for doing most of the work with this bug.

BugLink: https://bugs.launchpad.net/bugs/886975
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -548,24 +548,12 @@ static int conexant_build_controls(struc
 	return 0;
 }
 
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-static int conexant_suspend(struct hda_codec *codec, pm_message_t state)
-{
-	snd_hda_shutup_pins(codec);
-	return 0;
-}
-#endif
-
 static const struct hda_codec_ops conexant_patch_ops = {
 	.build_controls = conexant_build_controls,
 	.build_pcms = conexant_build_pcms,
 	.init = conexant_init,
 	.free = conexant_free,
 	.set_power_state = conexant_set_power,
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-	.suspend = conexant_suspend,
-#endif
-	.reboot_notify = snd_hda_shutup_pins,
 };
 
 #ifdef CONFIG_SND_HDA_INPUT_BEEP
@@ -4360,10 +4348,6 @@ static const struct hda_codec_ops cx_aut
 	.init = cx_auto_init,
 	.free = conexant_free,
 	.unsol_event = cx_auto_unsol_event,
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-	.suspend = conexant_suspend,
-#endif
-	.reboot_notify = snd_hda_shutup_pins,
 };
 
 /*


