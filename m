Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaDQKHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:07:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54923 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756289AbaDQJzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:55:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: perex@perex.cz, iwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/6] sound: lx_core: Remove unused defines
Date: Thu, 17 Apr 2014 11:51:16 +0200
Message-Id: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f9367f3fbe3c ("ALSA: lx6464es: Remove unused
function in pci/lx6464es/lx_core.c") removed the
lx_dsp_es_check_pipeline function that was the only user
of these defines.

Since they're useless now, simply remove them.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 sound/pci/lx6464es/lx_core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 2d8e95e9fbe5..6a1d90a308ea 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -429,11 +429,6 @@ int lx_dsp_read_async_events(struct lx6464es *chip, u32 *data)
 	return ret;
 }
 
-#define CSES_TIMEOUT        100     /* microseconds */
-#define CSES_CE             0x0001
-#define CSES_BROADCAST      0x0002
-#define CSES_UPDATE_LDSV    0x0004
-
 #define PIPE_INFO_TO_CMD(capture, pipe)					\
 	((u32)((u32)(pipe) | ((capture) ? ID_IS_CAPTURE : 0L)) << ID_OFFSET)
 
-- 
1.9.1

