Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab3GZRFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:05:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27777 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab3GZRFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:05:16 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] procfs: remove extra call of dir_emit_dots
Date: Fri, 26 Jul 2013 21:02:26 +0400
Message-Id: <1374858146-9004-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dir_emit_dots() is called twice. Looks like a typo.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/proc/fd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 75f2890..0ff80f9 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -230,8 +230,6 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
-	if (!dir_emit_dots(file, ctx))
-		goto out;
 	files = get_files_struct(p);
 	if (!files)
 		goto out;
-- 
1.8.3.1

