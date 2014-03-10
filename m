Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaCJUVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:21:04 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:47046 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaCJUVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:21:02 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        alsa-devel@alsa-project.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Revert "ALSA: emu10k1: Fix warning: "CCR" redefined"
Date: Mon, 10 Mar 2014 21:20:55 +0100
Message-Id: <1394482855-18836-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 83fc3bc09518d42e8f5073e2a65884701dfadf19.

sh-specific "CCR" and "CCR2" have been prefixed by "SH_" in commit
a5f6ea29f9a918403629f8369ae55fac6b09cb53 ('sh: prefix sh-specific "CCR" and
"CCR2" by "SH_"').

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/sound/emu10k1.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/sound/emu10k1.h b/include/sound/emu10k1.h
index dfb42ca6d043..c46908c1bb3f 100644
--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -436,8 +436,6 @@
 #define CCCA_CURRADDR_MASK	0x00ffffff	/* Current address of the selected channel		*/
 #define CCCA_CURRADDR		0x18000008
 
-/* undefine CCR to avoid conflict with the definition for SH */
-#undef CCR
 #define CCR			0x09		/* Cache control register				*/
 #define CCR_CACHEINVALIDSIZE	0x07190009
 #define CCR_CACHEINVALIDSIZE_MASK	0xfe000000	/* Number of invalid samples cache for this channel    	*/
-- 
1.7.9.5

