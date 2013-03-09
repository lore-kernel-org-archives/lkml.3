Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3CJW6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:58:19 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64218 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3CJW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:58:17 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] fs: pstore: Replaced calls to kmalloc and memcpy with kmemdup
Date: Sat,  9 Mar 2013 13:57:28 +0200
Message-Id: <1362830248-7017-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to kmalloc and memcpy with a single call to kmemdup.
This patch was found using coccicheck.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 fs/pstore/ram.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 288f068..38babb3 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -156,10 +156,9 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	time->tv_nsec = 0;
 
 	size = persistent_ram_old_size(prz);
-	*buf = kmalloc(size, GFP_KERNEL);
+	*buf = kmemdup(persistent_ram_old(prz), size, GFP_KERNEL);
 	if (*buf == NULL)
 		return -ENOMEM;
-	memcpy(*buf, persistent_ram_old(prz), size);
 
 	return size;
 }
-- 
1.7.9.5

