Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaFRRcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:32:10 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:43775 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbaFRRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:32:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0KAGDMoVNbtAr8/2dsb2JhbABagw2rOgUBAQEBAQEFAZkogQsXdYRgI4EaN4hGAc0lF4ViiRMdhC0Ej2yKV5NYg0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/squashfs/super.c: Logging clean-up
Date: Wed, 18 Jun 2014 19:30:47 +0200
Message-Id: <1403112647-7068-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Convert printk to pr_foo()
-Add pr_fmt for future logging entries
-Coalesce formats

Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/squashfs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 031c8d67..5056bab 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -27,6 +27,8 @@
  * the filesystem.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
@@ -448,8 +450,7 @@ static int __init init_squashfs_fs(void)
 		return err;
 	}
 
-	printk(KERN_INFO "squashfs: version 4.0 (2009/01/31) "
-		"Phillip Lougher\n");
+	pr_info("version 4.0 (2009/01/31) Phillip Lougher\n");
 
 	return 0;
 }
-- 
1.8.4.5

