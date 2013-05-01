Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3EATFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:05:16 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43079 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756691Ab3EATFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:05:11 -0400
From: Mike Travis <travis@sgi.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>
Subject: [PATCH]: x86_64, audio: Fix system panic when DMA > 40 bits
Date: Wed,  1 May 2013 14:04:08 -0500
Message-Id: <1367435048-66137-1-git-send-email-travis@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audio driver mistakenly allows 64 bit addresses to be created for
the audio driver on Nvidia GPUs.  Unfortunately, the hardware normally
only supports up to 40 bits of DMA.  This can cause system panics as
well as misdirected data when the address is > 40 bits as the upper
part the address is truncated.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
---
 sound/pci/hda/hda_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index bcd40ee..45eb165 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -615,7 +615,7 @@ enum {
 /* quirks for Nvidia */
 #define AZX_DCAPS_PRESET_NVIDIA \
 	(AZX_DCAPS_NVIDIA_SNOOP | AZX_DCAPS_RIRB_DELAY | AZX_DCAPS_NO_MSI |\
-	 AZX_DCAPS_ALIGN_BUFSIZE)
+	 AZX_DCAPS_ALIGN_BUFSIZE | AZX_DCAPS_NO_64BIT)
 
 #define AZX_DCAPS_PRESET_CTHDA \
 	(AZX_DCAPS_NO_MSI | AZX_DCAPS_POSFIX_LPIB | AZX_DCAPS_4K_BDLE_BOUNDARY)
-- 
1.8.2.1

