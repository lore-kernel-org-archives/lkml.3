Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3LJI1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:27:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3LJIAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 03/52] ALSA: hda - Fix headset mic input after muted internal mic (Dell/Realtek)
Date: Tue, 10 Dec 2013 00:00:36 -0800
Message-Id: <20131210075954.461246587@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit d59915d0655c5864b514f21daaeac98c047875dc upstream.

By trial and error, I found this patch could work around an issue
where the headset mic would stop working if you switch between the
internal mic and the headset mic, and the internal mic was muted.

It still takes a second or two before the headset mic actually starts
working, but still better than nothing.

Information update from Kailang:
  The verb was ADC digital mute(bit 6 default 1).
  Switch internal mic and headset mic will run alc_headset_mode_default.
  The coef index 0x11 will set to 0x0041.
  Because headset mode was fixed type. It doesn't need to run
  alc_determine_headset_type.
  So, the value still keep 0x0041. ADC was muted.

BugLink: https://bugs.launchpad.net/bugs/1256840
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3041,6 +3041,7 @@ static void alc_headset_mode_ctia(struct
 		alc_write_coef_idx(codec, 0x18, 0x7388);
 		break;
 	case 0x10ec0668:
+		alc_write_coef_idx(codec, 0x11, 0x0001);
 		alc_write_coef_idx(codec, 0x15, 0x0d60);
 		alc_write_coef_idx(codec, 0xc3, 0x0000);
 		break;
@@ -3063,6 +3064,7 @@ static void alc_headset_mode_omtp(struct
 		alc_write_coef_idx(codec, 0x18, 0x7388);
 		break;
 	case 0x10ec0668:
+		alc_write_coef_idx(codec, 0x11, 0x0001);
 		alc_write_coef_idx(codec, 0x15, 0x0d50);
 		alc_write_coef_idx(codec, 0xc3, 0x0000);
 		break;


