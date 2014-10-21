Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaJUPBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:01:25 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33872 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaJUPBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:01:23 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] ASoC: dapm: Remove redundant cast
Date: Tue, 21 Oct 2014 17:01:15 +0200
Message-Id: <1413903675-3363-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both path->name and e->texts[i] have type const char*, so the cast is
slightly confusing and certainly unnecessary.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index c61cb9c..39f992b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -496,7 +496,7 @@ static int dapm_connect_mux(struct snd_soc_dapm_context *dapm,
 			list_add(&path->list, &dapm->card->paths);
 			list_add(&path->list_sink, &dest->sources);
 			list_add(&path->list_source, &src->sinks);
-			path->name = (char*)e->texts[i];
+			path->name = e->texts[i];
 			if (i == item)
 				path->connect = 1;
 			else
-- 
2.0.4

