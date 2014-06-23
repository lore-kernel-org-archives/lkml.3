Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaFWP4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:56:41 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:41945 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaFWP4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:56:40 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: Jiri Kosina <trivial@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2] trivial: sound/core/seq/seq_memory.c: Fix closing brace followed by if
Date: Mon, 23 Jun 2014 17:56:09 +0200
Message-Id: <1403538969-26147-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403293803-17650-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403293803-17650-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a newline and, while at it, remove a space and redundant braces.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 sound/core/seq/seq_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index 1e206de..ba8e4a6 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -101,9 +101,9 @@ int snd_seq_dump_var_event(const struct snd_seq_event *event,
 			len -= size;
 		}
 		return 0;
-	} if (! (event->data.ext.len & SNDRV_SEQ_EXT_CHAINED)) {
-		return func(private_data, event->data.ext.ptr, len);
 	}
+	if (!(event->data.ext.len & SNDRV_SEQ_EXT_CHAINED))
+		return func(private_data, event->data.ext.ptr, len);
 
 	cell = (struct snd_seq_event_cell *)event->data.ext.ptr;
 	for (; len > 0 && cell; cell = cell->next) {
-- 
1.9.2

