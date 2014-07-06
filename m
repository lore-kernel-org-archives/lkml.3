Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaGFS7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:59:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34082 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaGFS7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:59:03 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: tdfxfb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 21:00:18 +0200
Message-Id: <1404673218-20500-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/tdfxfb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index f761fe3..4efb2de 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -224,9 +224,7 @@ static inline u8 crt_inb(struct tdfx_par *par, u32 idx)
 
 static inline void att_outb(struct tdfx_par *par, u32 idx, u8 val)
 {
-	unsigned char tmp;
-
-	tmp = vga_inb(par, IS1_R);
+	vga_inb(par, IS1_R);
 	vga_outb(par, ATT_IW, idx);
 	vga_outb(par, ATT_IW, val);
 }
-- 
1.7.10.4

