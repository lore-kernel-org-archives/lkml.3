Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3BQBoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 20:44:03 -0500
Received: from liberdade2.minaslivre.org ([74.50.53.203]:45004 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab3BQBoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 20:44:01 -0500
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Feb 2013 20:44:01 EST
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: geert@linux-m68k.org
Cc: gerg@uclinux.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] m68k/nommu: fix build when CPU is not coldfire
Date: Sat, 16 Feb 2013 23:33:34 -0200
Message-Id: <1361064814-9727-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit dd1cb3a7c43508c29e17836628090c0735bd3137 unified mm/init.c for both MMU
and non-MMU m68k platforms. However, it broke when we build a non-MMU M68K
Classic CPU kernel.

This fix builds a section that came from the MMU version only when we are
building a MMU kernel.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 arch/m68k/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index afd8106f..519aad8 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -188,7 +188,7 @@ void __init mem_init(void)
 		}
 	}
 
-#if !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
+#if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
 	/* insert pointer tables allocated so far into the tablelist */
 	init_pointer_table((unsigned long)kernel_pg_dir);
 	for (i = 0; i < PTRS_PER_PGD; i++) {
-- 
1.7.10.4

