Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874AbaCUAEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479AbaCUAD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 052/149] ALSA: hda - Use analog beep for Thinkpads with AD1984 codecs
Date: Thu, 20 Mar 2014 17:03:35 -0700
Message-Id: <20140321000438.767062660@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f3e9b59cb948e2328bc06635ad39572d5b7b4791 upstream.

For making the driver behavior compatible with the earlier kernels,
use the analog beep in the loopback path instead of the digital beep.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1025,6 +1025,9 @@ static void ad1884_fixup_thinkpad(struct
 		spec->gen.keep_eapd_on = 1;
 		spec->gen.vmaster_mute.hook = ad_vmaster_eapd_hook;
 		spec->eapd_nid = 0x12;
+		/* Analog PC Beeper - allow firmware/ACPI beeps */
+		spec->beep_amp = HDA_COMPOSE_AMP_VAL(0x20, 3, 3, HDA_INPUT);
+		spec->gen.beep_nid = 0; /* no digital beep */
 	}
 }
 


