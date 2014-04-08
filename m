Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbaDHTGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:06:40 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:53048 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaDHTGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:06:37 -0400
From: Dylan Reid <dgreid@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, Dylan Reid <dgreid@chromium.org>
Subject: [PATCH] ALSA: hda - Use runtime helper to check active state.
Date: Tue,  8 Apr 2014 12:06:18 -0700
Message-Id: <1396983978-12907-1-git-send-email-dgreid@chromium.org>
X-Mailer: git-send-email 1.8.1.3.605.g02339dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From azx_interrupt, use the helper to check if the device is active
instead of checking the state.  This will do the right thing if
runtime pm is disabled in addition to if the device is suspended.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
---
 sound/pci/hda/hda_controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 97993e1..460fcf4 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -1758,7 +1758,7 @@ irqreturn_t azx_interrupt(int irq, void *dev_id)
 
 #ifdef CONFIG_PM_RUNTIME
 	if (chip->driver_caps & AZX_DCAPS_PM_RUNTIME)
-		if (chip->card->dev->power.runtime_status != RPM_ACTIVE)
+		if (!pm_runtime_active(chip->card->dev))
 			return IRQ_NONE;
 #endif
 
-- 
1.8.1.3.605.g02339dd

