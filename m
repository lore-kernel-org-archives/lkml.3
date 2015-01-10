Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbbAJAvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:51:49 -0500
Received: from nupi.pair.com ([209.68.5.149]:35608 "EHLO nupi.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbbAJAvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:51:48 -0500
Message-ID: <54B077A3.7030703@flaterco.com>
Date: Fri, 09 Jan 2015 19:51:47 -0500
From: David Flater <vger@flaterco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
        Alsa Devel <alsa-devel@alsa-project.org>
Subject: [PATCHv2 2/2] ALSA: log emu8000 DRAM size at level INFO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applicable after PATCHv2 1/2:

Detected sound font memory goes unreported unless the kernel was built with
ALSA debugging enabled.  Elevate that to a printk at level INFO.

Signed-off-by: David Flater <dave@flaterco.com>
---
History:
2015-01-09  v2: In response to feedback from Takashi Iwai,
               1. Optimize for diff size.
                 1a. Use goto to avoid indenting.
                 1b. Jettison new debugging printouts.
               2. Split printk into second patch.
            Retested on CT4390 (4 MiB) and CT4380 (512 KiB).
2015-01-08  v1 patch sent to LKML, Alsa Devel and maintainers.  Tested on
            unexpanded CT4390 (4 MiB), CT4520 (512 KiB), and CT4380 (512
            KiB).

 sound/isa/sb/emu8000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/isa/sb/emu8000.c b/sound/isa/sb/emu8000.c
index 3dcf80e..7429a51 100644
--- a/sound/isa/sb/emu8000.c
+++ b/sound/isa/sb/emu8000.c
@@ -451,7 +451,7 @@ size_dram(struct snd_emu8000 *emu)
 	snd_emu8000_dma_chan(emu, 0, EMU8000_RAM_CLOSE);
 	snd_emu8000_dma_chan(emu, 1, EMU8000_RAM_CLOSE);
 
-	snd_printdd("EMU8000 [0x%lx]: %d Kb on-board memory detected\n",
+	snd_printk(KERN_INFO "EMU8000 [0x%lx]: %d KiB on-board DRAM detected\n",
 		    emu->port1, size/1024);
 
 	emu->mem_size = size;
-- 
1.8.4

