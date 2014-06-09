Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbaFIJCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:02:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58518 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755042AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/146] ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
Date: Mon,  9 Jun 2014 10:50:31 +0200
Message-Id: <802a761e60de3562427cb2c80191aa38f1c165c6.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 77f07800cb456bed6e5c345e6e4e83e8eda62437 upstream.

The recent Intel H97/Z97 chipsets need the similar setups like other
Intel chipsets for snooping, etc.  Especially without snooping, the
audio playback stutters or gets corrupted.  This fix patch just adds
the corresponding PCI ID entry with the proper flags.

Reported-and-tested-by: Arthur Borsboom <arthurborsboom@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index b5c4c2e4360b..ee1a6ff120a2 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3986,6 +3986,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* Lynx Point */
 	{ PCI_DEVICE(0x8086, 0x8c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	/* 9 Series */
+	{ PCI_DEVICE(0x8086, 0x8ca0),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Wellsburg */
 	{ PCI_DEVICE(0x8086, 0x8d20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
-- 
1.9.3

