Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaJ1DjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:39:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaJ1DjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Harsha Priya <harshapriya.n@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 074/146] ALSA: ALC283 codec - Avoid pop noise on headphones during suspend/resume
Date: Tue, 28 Oct 2014 11:33:36 +0800
Message-Id: <20141028033346.595511848@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harsha Priya <harshapriya.n@intel.com>

commit b450b17c156e264bc44a198046d3ebaaef5a041d upstream.

This patch sets the headphones mode to default before suspending
which helps avoid the pop noise on headphones

Signed-off-by: Harsha Priya <harshapriya.n@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3125,6 +3125,9 @@ static void alc283_shutup(struct hda_cod
 
 	alc_write_coef_idx(codec, 0x43, 0x9004);
 
+	/*depop hp during suspend*/
+	alc_write_coef_idx(codec, 0x06, 0x2100);
+
 	snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
 


