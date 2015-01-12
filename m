Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbbALIkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:40:37 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:39065 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbALIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:40:27 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, alsa-devel@alsa-project.org
Subject: [PATCH 4/5] sound: dmasound_atari: Remove obsolete IRQ_TYPE_SLOW
Date: Mon, 12 Jan 2015 09:40:20 +0100
Message-Id: <1421052021-12560-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
References: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ_TYPE_SLOW is no longer used by the Atari platform interrupt code
since commit 734085651c9b80aa ("[PATCH] m68k: convert atari irq code")
in v2.6.18-rc1, so drop it.

Note that its value has been reused for a different purpose
(IRQ_TYPE_NONE) since commit 6a6de9ef5850d063 ("[PATCH] genirq: core")
in v2.6.18-rc1.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: alsa-devel@alsa-project.org
---
 sound/oss/dmasound/dmasound_atari.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/oss/dmasound/dmasound_atari.c b/sound/oss/dmasound/dmasound_atari.c
index 13c214466d3b9f0e..1c56bf58eff906e0 100644
--- a/sound/oss/dmasound/dmasound_atari.c
+++ b/sound/oss/dmasound/dmasound_atari.c
@@ -851,7 +851,7 @@ static int __init AtaIrqInit(void)
 	st_mfp.tim_dt_a = 1;	/* Cause interrupt after first event. */
 	st_mfp.tim_ct_a = 8;	/* Turn on event counting. */
 	/* Register interrupt handler. */
-	if (request_irq(IRQ_MFP_TIMA, AtaInterrupt, IRQ_TYPE_SLOW, "DMA sound",
+	if (request_irq(IRQ_MFP_TIMA, AtaInterrupt, 0, "DMA sound",
 			AtaInterrupt))
 		return 0;
 	st_mfp.int_en_a |= 0x20;	/* Turn interrupt on. */
-- 
1.9.1

