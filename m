Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010Ab3GWWxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:53:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934290Ab3GWW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 027/103] ALSA: hda - Fix return value of snd_hda_check_power_state()
Date: Tue, 23 Jul 2013 15:25:38 -0700
Message-Id: <20130723220421.620981187@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 06ec56d3c60238f27bfa50d245592fccc1b4ef0f upstream.

The refactoring by commit 9040d102 introduced the new function
snd_hda_check_power_state().  This function is supposed to return true
if the state already reached to the target state, but it actually
returns false for that.  An utterly stupid typo while copy & paste.

Fortunately this didn't influence on much behavior because powering up
AFG usually powers up the child widgets, too.  But the finer power
control must have been broken by this bug.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_local.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -667,7 +667,7 @@ snd_hda_check_power_state(struct hda_cod
 	if (state & AC_PWRST_ERROR)
 		return true;
 	state = (state >> 4) & 0x0f;
-	return (state != target_state);
+	return (state == target_state);
 }
 
 unsigned int snd_hda_codec_eapd_power_filter(struct hda_codec *codec,


