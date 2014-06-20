Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934906AbaFTPue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:50:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61464 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaFTPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:50:29 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Vincent Heuken <me@vincentheuken.com>
Subject: [PATCH] Sound: Core: fixed assignment in if condition style error in hwdep.c
Date: Fri, 20 Jun 2014 08:50:35 -0700
Message-Id: <1403279435-31231-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the hwdep.c file that fixes one instance of
the following error:
ERROR: do not use assignment in if condition

It also, incidentally, fixes one instance of the following warning:
WARNING: line over 80 characters

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 sound/core/hwdep.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 69459e5..42d8324 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -527,7 +527,9 @@ static void __init snd_hwdep_proc_init(void)
 {
 	struct snd_info_entry *entry;
 
-	if ((entry = snd_info_create_module_entry(THIS_MODULE, "hwdep", NULL)) != NULL) {
+	entry = snd_info_create_module_entry(THIS_MODULE, "hwdep", NULL);
+
+	if (entry != NULL) {
 		entry->c.text.read = snd_hwdep_proc_read;
 		if (snd_info_register(entry) < 0) {
 			snd_info_free_entry(entry);
-- 
2.0.0

