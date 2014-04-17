Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaDQJzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:55:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54923 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754603AbaDQJzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:55:10 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: perex@perex.cz, iwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/6] sound: lx_core: Remove useless #if 0 .. #endif
Date: Thu, 17 Apr 2014 11:51:20 +0200
Message-Id: <1397728281-26050-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code contained in these sections are only dev_dbg calls, that are already
removed whenever DEBUG isn't defined.

Remove the redundant constructs.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 sound/pci/lx6464es/lx_core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 0ad6358b5fe2..7c070864dc62 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -515,7 +515,6 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
 				*r_needed += 1;
 		}
 
-#if 0
 		dev_dbg(chip->card->dev,
 			"CMD_08_ASK_BUFFERS: needed %d, freed %d\n",
 			    *r_needed, *r_freed);
@@ -526,7 +525,6 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
 					    chip->rmh.stat[i],
 					    chip->rmh.stat[i] & MASK_DATA_SIZE);
 		}
-#endif
 	}
 
 	spin_unlock_irqrestore(&chip->msg_lock, flags);
@@ -1191,7 +1189,6 @@ irqreturn_t lx_interrupt(int irq, void *dev_id)
 	if (irqsrc & MASK_SYS_STATUS_CMD_DONE)
 		goto exit;
 
-#if 0
 	if (irqsrc & MASK_SYS_STATUS_EOBI)
 		dev_dbg(chip->card->dev, "interrupt: EOBI\n");
 
@@ -1203,7 +1200,6 @@ irqreturn_t lx_interrupt(int irq, void *dev_id)
 
 	if (irqsrc & MASK_SYS_STATUS_ORUN)
 		dev_dbg(chip->card->dev, "interrupt: ORUN\n");
-#endif
 
 	if (async_pending) {
 		u64 notified_in_pipe_mask = 0;
@@ -1230,7 +1226,6 @@ irqreturn_t lx_interrupt(int irq, void *dev_id)
 	}
 
 	if (async_escmd) {
-#if 0
 		/* backdoor for ethersound commands
 		 *
 		 * for now, we do not need this
@@ -1238,7 +1233,6 @@ irqreturn_t lx_interrupt(int irq, void *dev_id)
 		 * */
 
 		dev_dbg(chip->card->dev, "interrupt requests escmd handling\n");
-#endif
 	}
 
 exit:
-- 
1.9.1

