Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaBFJOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:14:23 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:33541 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703AbaBFJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:14:18 -0500
X-Mailbox-Line: From 1db1cec6e98c5cc764cc57e9f3753e4a38d21817 Mon Sep 17 00:00:00 2001
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 6 Feb 2014 09:41:48 +0100
Subject: [PATCH] ALSA: pcm: export some constraint functions
To: perex@perex.cz, tiwai@suse.de
Cc: lars@metafoo.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-Id: <20140206091402.5F54D940120@smtp1-g21.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions snd_pcm_hw_constraint_mask() and
snd_pcm_hw_constraint_mask64() are needed to add audio constraints
to substreams at open/startup time.
This patch makes them available to ALSA modules.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/core/pcm_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index a210467..aea4972 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1219,6 +1219,7 @@ int snd_pcm_hw_constraint_mask(struct snd_pcm_runtime *runtime, snd_pcm_hw_param
 		return -EINVAL;
 	return 0;
 }
+EXPORT_SYMBOL(snd_pcm_hw_constraint_mask);
 
 /**
  * snd_pcm_hw_constraint_mask64 - apply the given bitmap mask constraint
@@ -1242,6 +1243,7 @@ int snd_pcm_hw_constraint_mask64(struct snd_pcm_runtime *runtime, snd_pcm_hw_par
 		return -EINVAL;
 	return 0;
 }
+EXPORT_SYMBOL(snd_pcm_hw_constraint_mask64);
 
 /**
  * snd_pcm_hw_constraint_integer - apply an integer constraint to an interval
-- 
1.9.rc1

