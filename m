Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab3K0BAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770Ab3K0A7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 053/116] ALSA: hda - Dont turn off EAPD for headphone on Lenovo N100
Date: Tue, 26 Nov 2013 16:57:06 -0800
Message-Id: <20131127005740.613142069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7a3e6107f94344e65c35bfe62de6c096a7b48965 upstream.

The only EAPD on AD1986A is on NID 0x1b where usually the speaker.
But this doesn't control only the speaker amp but may influence on all
outputs, e.g. Lenovo N100 laptop seems to have this issue.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -219,8 +219,12 @@ static int alloc_ad_spec(struct hda_code
 static void ad_fixup_inv_jack_detect(struct hda_codec *codec,
 				     const struct hda_fixup *fix, int action)
 {
-	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+	struct ad198x_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		codec->inv_jack_detect = 1;
+		spec->gen.keep_eapd_on = 1;
+	}
 }
 
 enum {


