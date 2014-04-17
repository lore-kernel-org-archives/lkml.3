Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaDQJzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:55:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54919 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754602AbaDQJzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:55:09 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: perex@perex.cz, iwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/6] sound: lx_core: Remove dead code
Date: Thu, 17 Apr 2014 11:51:19 +0200
Message-Id: <1397728281-26050-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code was never compiled because hidden between an #if 0 .. #endif
structure, and even when removing these, it was never actually used elsewhere.
Remove it entirely.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 sound/pci/lx6464es/lx_core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 9e0acba82751..0ad6358b5fe2 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -1041,10 +1041,6 @@ static int lx_interrupt_handle_async_events(struct lx6464es *chip, u32 irqsrc,
 
 	u64 orun_mask;
 	u64 urun_mask;
-#if 0
-	int has_underrun   = (irqsrc & MASK_SYS_STATUS_URUN) ? 1 : 0;
-	int has_overrun    = (irqsrc & MASK_SYS_STATUS_ORUN) ? 1 : 0;
-#endif
 	int eb_pending_out = (irqsrc & MASK_SYS_STATUS_EOBO) ? 1 : 0;
 	int eb_pending_in  = (irqsrc & MASK_SYS_STATUS_EOBI) ? 1 : 0;
 
-- 
1.9.1

