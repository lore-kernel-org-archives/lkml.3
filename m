Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaE2Q62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:58:28 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:50146 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932331AbaE2Q60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:58:26 -0400
Message-ID: <1401382705.25908.9.camel@x220>
Subject: [PATCH] sound: remove checks for CONFIG_SND_DEBUG_ROM
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2014 18:58:25 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2014 16:58:25.0791 (UTC) FILETIME=[34F980F0:01CF7B5F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks for CONFIG_SND_DEBUG_ROM were added in v2.5.5 but a Kconfig
symbol SND_DEBUG_ROM was never added. These checks have always
evaluated to false. Remove them and the printk()s they hide.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Perhaps one is expected to define this debugging macro by hand, somehow.
In that case it would be nice to drop the CONFIG_ prefix.

 sound/isa/gus/interwave.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index 5abbbe477d16..ad55e5cb8e94 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -442,17 +442,11 @@ static void snd_interwave_detect_memory(struct snd_gus_card *gus)
 	for (bank_pos = 0; bank_pos < 16L * 1024L * 1024L; bank_pos += 4L * 1024L * 1024L) {
 		for (i = 0; i < 8; ++i)
 			iwave[i] = snd_gf1_peek(gus, bank_pos + i);
-#ifdef CONFIG_SND_DEBUG_ROM
-		printk(KERN_DEBUG "ROM at 0x%06x = %8phC\n", bank_pos, iwave);
-#endif
 		if (strncmp(iwave, "INTRWAVE", 8))
 			continue;	/* first check */
 		csum = 0;
 		for (i = 0; i < sizeof(struct rom_hdr); i++)
 			csum += snd_gf1_peek(gus, bank_pos + i);
-#ifdef CONFIG_SND_DEBUG_ROM
-		printk(KERN_DEBUG "ROM checksum = 0x%x (computed)\n", csum);
-#endif
 		if (csum != 0)
 			continue;	/* not valid rom */
 		gus->gf1.rom_banks++;
-- 
1.9.3

