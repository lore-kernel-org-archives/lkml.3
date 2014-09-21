Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaIUQEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:04:30 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58052 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaIUQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:04:07 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] sound: pci: ctxfi: cthw20k1.c: sparse warning of incorrect type
Date: Sun, 21 Sep 2014 21:33:41 +0530
Message-Id: <1411315421-24138-5-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning incorrect type (different address spaces)

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/cthw20k1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index b807391..76db449 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -1803,7 +1803,7 @@ static int uaa_to_xfi(struct pci_dev *pci)
 	unsigned int is_uaa;
 	unsigned int data[4] = {0};
 	unsigned int io_base;
-	void *mem_base;
+	void __iomem *mem_base;
 	int i;
 	const u32 CTLX = CTLBITS('C', 'T', 'L', 'X');
 	const u32 CTL_ = CTLBITS('C', 'T', 'L', '-');
@@ -1987,7 +1987,7 @@ static int hw_card_shutdown(struct hw *hw)
 	hw->irq	= -1;
 
 	if (hw->mem_base)
-		iounmap((void *)hw->mem_base);
+		iounmap((void __iomem *)hw->mem_base);
 
 	hw->mem_base = (unsigned long)NULL;
 
-- 
1.8.1.2

