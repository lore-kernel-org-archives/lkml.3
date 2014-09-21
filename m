Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaIUQEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:04:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35604 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaIUQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:04:04 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] sound: pci: ctxfi: cthw20k2.c: sparse warning of incorrect type
Date: Sun, 21 Sep 2014 21:33:40 +0530
Message-Id: <1411315421-24138-4-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning of incorrect type (different address spaces)

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/cthw20k2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index 665eeb2..25ef60b 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -2112,7 +2112,7 @@ static int hw_card_shutdown(struct hw *hw)
 	hw->irq	= -1;
 
 	if (hw->mem_base)
-		iounmap((void *)hw->mem_base);
+		iounmap((void __iomem *)hw->mem_base);
 
 	hw->mem_base = (unsigned long)NULL;
 
@@ -2234,12 +2234,12 @@ static int hw_resume(struct hw *hw, struct card_conf *info)
 
 static u32 hw_read_20kx(struct hw *hw, u32 reg)
 {
-	return readl((void *)(hw->mem_base + reg));
+	return readl((void __iomem *)(hw->mem_base + reg));
 }
 
 static void hw_write_20kx(struct hw *hw, u32 reg, u32 data)
 {
-	writel(data, (void *)(hw->mem_base + reg));
+	writel(data, (void __iomem *)(hw->mem_base + reg));
 }
 
 static struct hw ct20k2_preset = {
-- 
1.8.1.2

