Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab3HGWHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:07:06 -0400
Received: from ares07.inai.de ([5.9.24.206]:59999 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549Ab3HGWHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:07:03 -0400
From: Jan Engelhardt <jengelh@inai.de>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] depmod: add missing "else" clause
Date: Wed,  7 Aug 2013 23:58:58 +0200
Message-Id: <1375912738-25114-2-git-send-email-jengelh@inai.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1375912738-25114-1-git-send-email-jengelh@inai.de>
References: <1375912738-25114-1-git-send-email-jengelh@inai.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It occurred to an openSUSE user that our mkinitrd would throw a
warning when used with kmod:

libkmod: conf_files_list: unsupported file mode /dev/null: 0x21b6

Grepping for the error message revealed that there might be a missing
"else" keyword here, since it is unusual to put an "if" directly after
closing brace.
---
 libkmod/libkmod-config.c | 2 +-
 tools/depmod.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libkmod/libkmod-config.c b/libkmod/libkmod-config.c
index 201c349..cb4cf61 100644
--- a/libkmod/libkmod-config.c
+++ b/libkmod/libkmod-config.c
@@ -833,7 +833,7 @@ static int conf_files_list(struct kmod_ctx *ctx, struct kmod_list **list,
 	if (S_ISREG(st.st_mode)) {
 		conf_files_insert_sorted(ctx, list, path, NULL);
 		return 0;
-	} if (!S_ISDIR(st.st_mode)) {
+	} else if (!S_ISDIR(st.st_mode)) {
 		ERR(ctx, "unsupported file mode %s: %#x\n",
 							path, st.st_mode);
 		return -EINVAL;
diff --git a/tools/depmod.c b/tools/depmod.c
index 4a02631..985cf3a 100644
--- a/tools/depmod.c
+++ b/tools/depmod.c
@@ -848,7 +848,7 @@ static int cfg_files_list(struct cfg_file ***p_files, size_t *p_n_files,
 	if (S_ISREG(st.st_mode)) {
 		cfg_files_insert_sorted(p_files, p_n_files, path, NULL);
 		return 0;
-	} if (!S_ISDIR(st.st_mode)) {
+	} else if (!S_ISDIR(st.st_mode)) {
 		ERR("unsupported file mode %s: %#x\n", path, st.st_mode);
 		return -EINVAL;
 	}
-- 
1.8.2

