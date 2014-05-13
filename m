Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaEMSin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:38:43 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:38267 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbaEMSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:38:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYVAGxlclNbtADP/2dsb2JhbABZgwaseAQBAQEBAQEFAZoZAgKBIxd0glMTHCMYgQIkE4hFAccohVSIeoRHAQOPKYomAZMQgzg7
Date: Tue, 13 May 2014 20:38:32 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joel Becker <jlbec@evilplan.org>, Joe Perches <joe@perches.com>,
        akpm <akpm@linux-foundation.org>
Subject: [RFC 1/1] fs/configfs/dir.c: remove unused debugging functions
Message-Id: <20140513203832.cb793ce47b8af993f561e5c2@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches noticed it was not used anywhere.
If there's no plan to use it in the future,
we could simply remove both functions ...

Cc: Joe Perches <joe@perches.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/configfs/dir.c | 37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index e081acb..1b12d0a 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -937,43 +937,6 @@ static void client_drop_item(struct config_item *parent_item,
 		config_item_put(item);
 }
 
-#ifdef DEBUG
-static void configfs_dump_one(struct configfs_dirent *sd, int level)
-{
-	printk(KERN_INFO "%*s\"%s\":\n", level, " ", configfs_get_name(sd));
-
-#define type_print(_type) if (sd->s_type & _type) printk(KERN_INFO "%*s %s\n", level, " ", #_type);
-	type_print(CONFIGFS_ROOT);
-	type_print(CONFIGFS_DIR);
-	type_print(CONFIGFS_ITEM_ATTR);
-	type_print(CONFIGFS_ITEM_LINK);
-	type_print(CONFIGFS_USET_DIR);
-	type_print(CONFIGFS_USET_DEFAULT);
-	type_print(CONFIGFS_USET_DROPPING);
-#undef type_print
-}
-
-static int configfs_dump(struct configfs_dirent *sd, int level)
-{
-	struct configfs_dirent *child_sd;
-	int ret = 0;
-
-	configfs_dump_one(sd, level);
-
-	if (!(sd->s_type & (CONFIGFS_DIR|CONFIGFS_ROOT)))
-		return 0;
-
-	list_for_each_entry(child_sd, &sd->s_children, s_sibling) {
-		ret = configfs_dump(child_sd, level + 2);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-#endif
-
-
 /*
  * configfs_depend_item() and configfs_undepend_item()
  *
-- 
1.8.4.5

