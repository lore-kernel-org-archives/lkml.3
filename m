Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbaFYMR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:17:29 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:41163 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaFYMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:17:28 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Julia Lawall <Julia.Lawall@lip6.fr>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: oss: mpu401.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 14:18:24 +0200
Message-Id: <1403698704-22364-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A struct member variable is set to the same value more than once

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/oss/mpu401.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/oss/mpu401.c b/sound/oss/mpu401.c
index 3bbc3ec..31d7f72 100644
--- a/sound/oss/mpu401.c
+++ b/sound/oss/mpu401.c
@@ -972,7 +972,6 @@ int attach_mpu401(struct address_info *hw_config, struct module *owner)
 	devc->m_busy = 0;
 	devc->m_state = ST_INIT;
 	devc->shared_irq = hw_config->always_detect;
-	devc->irq = hw_config->irq;
 	spin_lock_init(&devc->lock);
 
 	if (devc->irq < 0)
-- 
1.7.10.4

