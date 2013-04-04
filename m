Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764897Ab3DDUcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:32:19 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51046 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764834Ab3DDUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:32:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3/5] SOUND: hda_generic, fix uninitialized variable
Date: Thu,  4 Apr 2013 22:32:10 +0200
Message-Id: <1365107532-32721-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
References: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed is not initialized in path_power_down_sync, but it is expected
to be false in case no change happened in the loop. So set it to
false.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/hda/hda_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index f0a422f..8299e40 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -751,7 +751,7 @@ EXPORT_SYMBOL_HDA(snd_hda_activate_path);
 static void path_power_down_sync(struct hda_codec *codec, struct nid_path *path)
 {
 	struct hda_gen_spec *spec = codec->spec;
-	bool changed;
+	bool changed = false;
 	int i;
 
 	if (!spec->power_down_unused || path->active)
-- 
1.8.2


