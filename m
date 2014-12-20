Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaLTRAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 12:00:39 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:55909 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaLTRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 12:00:38 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: isa: gus: gus_instr.c:  Remove unused function
Date: Sat, 20 Dec 2014 18:03:24 +0100
Message-Id: <1419095004-9727-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function snd_gus_simple_remove_sample() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/isa/gus/gus_instr.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/sound/isa/gus/gus_instr.c b/sound/isa/gus/gus_instr.c
index 4dc9caf..2d21408 100644
--- a/sound/isa/gus/gus_instr.c
+++ b/sound/isa/gus/gus_instr.c
@@ -162,11 +162,3 @@ int snd_gus_simple_get_sample(void *private_data, struct simple_instrument *inst
 
 	return snd_gus_dram_read(gus, data, instr->address.memory, instr->size, 0);
 }
-
-int snd_gus_simple_remove_sample(void *private_data, struct simple_instrument *instr,
-			         int atomic)
-{
-	struct snd_gus_card *gus = private_data;
-
-	return snd_gf1_mem_free(&gus->gf1.mem_alloc, instr->address.memory);
-}
-- 
1.7.10.4

