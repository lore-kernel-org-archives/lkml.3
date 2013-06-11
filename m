Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3FKUPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:15:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab3FKUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Riesen <raa.lkml@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 34/79] ALSA: hda/via - Disable broken dynamic power control
Date: Tue, 11 Jun 2013 13:03:00 -0700
Message-Id: <20130611195316.916102666@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 087c2e3b4e062573dbbc8a50b9208992e3768dcf upstream.

Since the transition to the generic parser, the actual routes used
there don't match always with the assumed static paths in some
set_widgets_power_state callbacks.  This results in the wrong power
setup in the end.  As a temporary workaround, we need to disable the
calls together with the non-functional dynamic power control enum.

Reported-by: Alex Riesen <raa.lkml@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -231,9 +231,14 @@ static void vt1708_update_hp_work(struct
 
 static void set_widgets_power_state(struct hda_codec *codec)
 {
+#if 0 /* FIXME: the assumed connections don't match always with the
+       * actual routes by the generic parser, so better to disable
+       * the control for safety.
+       */
 	struct via_spec *spec = codec->spec;
 	if (spec->set_widgets_power_state)
 		spec->set_widgets_power_state(codec);
+#endif
 }
 
 static void update_power_state(struct hda_codec *codec, hda_nid_t nid,


