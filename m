Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaBXLUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:20:23 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44466 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBXLUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:20:22 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dcache: replace obsolete simple_strtoul() with kstrtoul()
Date: Mon, 24 Feb 2014 20:20:16 +0900
Message-ID: <1700307.8D3KhEYTno@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/dcache.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 265e0ce..f360620 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3345,10 +3345,9 @@ EXPORT_SYMBOL(d_tmpfile);
 static __initdata unsigned long dhash_entries;
 static int __init set_dhash_entries(char *str)
 {
-	if (!str)
-		return 0;
-	dhash_entries = simple_strtoul(str, &str, 0);
-	return 1;
+	if (str && !kstrtoul(str, 0, &dhash_entries))
+		return 1;
+	return 0;
 }
 __setup("dhash_entries=", set_dhash_entries);
 
-- 
1.7.9.5

---
