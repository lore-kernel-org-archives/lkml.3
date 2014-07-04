Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031750AbaGDWyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:54:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030536AbaGDWRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pierre Ossman <pierre@ossman.eu>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.15 64/66] ALSA: hda - hdmi: call overridden init on resume
Date: Fri,  4 Jul 2014 15:15:03 -0700
Message-Id: <20140704221425.740359237@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Ossman <pierre@ossman.eu>

commit a283368382c50345dff61525f493ea307f21ec9b upstream.

We need to call the proper init function in case it has been
overridden, as it might restore things that the generic routing
doesn't know anything about. E.g. AMD cards have special verbs
that need resetting.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=77901
Fixes: 5a61358433b1 ('ALSA: hda - hdmi: Add ATI/AMD multi-channel audio support')
Signed-off-by: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2208,7 +2208,7 @@ static int generic_hdmi_resume(struct hd
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx;
 
-	generic_hdmi_init(codec);
+	codec->patch_ops.init(codec);
 	snd_hda_codec_resume_amp(codec);
 	snd_hda_codec_resume_cache(codec);
 


