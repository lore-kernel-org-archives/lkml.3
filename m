Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3LJIS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:18:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3LJIBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 03/62] ALSA: hda - Use always amps for auto-mute on AD1986A codec
Date: Tue, 10 Dec 2013 00:00:34 -0800
Message-Id: <20131210080057.650515237@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b3bd4fc3822a6b5883eaa556822487d87752d443 upstream.

It seems that AD1986A cannot manage the dynamic pin on/off for
auto-muting, but rather gets confused.  Since each output has own amp,
let's use it instead.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64971
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -345,6 +345,9 @@ static int patch_ad1986a(struct hda_code
 	 */
 	spec->gen.multiout.no_share_stream = 1;
 
+	/* AD1986A can't manage the dynamic pin on/off smoothly */
+	spec->gen.auto_mute_via_amp = 1;
+
 	snd_hda_pick_fixup(codec, ad1986a_fixup_models, ad1986a_fixup_tbl,
 			   ad1986a_fixups);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);


