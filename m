Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaDQJzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:55:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54909 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbaDQJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:55:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: perex@perex.cz, iwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/6] sound: lx_core: Fix dev_dbg typo
Date: Thu, 17 Apr 2014 11:51:18 +0200
Message-Id: <1397728281-26050-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit be4e6d3c0fa0 ("ALSA: lx6464es: Use standard printk helpers") converted
the custom printk helpers that were used before to standard dev_* functions.
One of the dev_dbg calls had a typo, that was hidden away by an #if 0 .. #endif

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 sound/pci/lx6464es/lx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 652f6dfc7e1a..9e0acba82751 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -1197,7 +1197,7 @@ irqreturn_t lx_interrupt(int irq, void *dev_id)
 
 #if 0
 	if (irqsrc & MASK_SYS_STATUS_EOBI)
-		dev_dgg(chip->card->dev, "interrupt: EOBI\n");
+		dev_dbg(chip->card->dev, "interrupt: EOBI\n");
 
 	if (irqsrc & MASK_SYS_STATUS_EOBO)
 		dev_dbg(chip->card->dev, "interrupt: EOBO\n");
-- 
1.9.1

