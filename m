Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903Ab3CLWvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:51:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3CLWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 40/40] Revert "ALSA: hda - hdmi: Make jacks phantom, if theyre not detectable"
Date: Tue, 12 Mar 2013 15:44:01 -0700
Message-Id: <20130312223215.783517875@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 30efd8debd1ef30be342d374f01e993509f5b76b upstream
(dd54ec4067a23236736afecbda120030d7ce8fe9 in this tree) as it is not
needed for the 3.4-stable tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Henningsson <david.henningsson@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>

---
 sound/pci/hda/patch_hdmi.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1244,9 +1244,6 @@ static int generic_hdmi_build_jack(struc
 
 	if (pcmdev > 0)
 		sprintf(hdmi_str + strlen(hdmi_str), ",pcm=%d", pcmdev);
-	if (!is_jack_detectable(codec, per_pin->pin_nid))
-		strncat(hdmi_str, " Phantom",
-			sizeof(hdmi_str) - strlen(hdmi_str) - 1);
 
 	return snd_hda_jack_add_kctl(codec, per_pin->pin_nid, hdmi_str, 0);
 }


