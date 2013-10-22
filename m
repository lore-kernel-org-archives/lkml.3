Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3JVNON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:14:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26040 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3JVNOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:14:11 -0400
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Shmulik Ladkani" <shmulik.ladkani@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 1/2] block: remove unrelated header files and export symbol
Thread-Topic: [PATCH 1/2] block: remove unrelated header files and export
 symbol
Thread-Index: AQHOzyhlGv+9SlYr/UGKp0tDdOhpoA==
Date: Tue, 22 Oct 2013 13:12:44 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C084C73@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
 <20131020120603.GA18678@localhost>
In-Reply-To: <20131020120603.GA18678@localhost>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.21]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9MDEJW4006102

From: CaiZhiyong <caizhiyong@huawei.com>
Subject: block: remove unrelated header files and export symbol

This patch fix up the following items:
 - remove unrelated header files.
 - export interface function.
 - modify function cmdline_parts_parse return value, this will make
   it more friendly for the caller.

Signed-off-by: CaiZhiyong <caizhiyong@huawei.com>
---
 block/cmdline-parser.c         | 18 +++++++++++-------
 include/linux/cmdline-parser.h |  8 ++++----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/block/cmdline-parser.c b/block/cmdline-parser.c
index cc2637f..9dbc67e 100644
--- a/block/cmdline-parser.c
+++ b/block/cmdline-parser.c
@@ -4,8 +4,7 @@
  * Written by Cai Zhiyong <caizhiyong@huawei.com>
  *
  */
-#include <linux/buffer_head.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/cmdline-parser.h>
 
 static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
@@ -159,6 +158,7 @@ void cmdline_parts_free(struct cmdline_parts **parts)
 		*parts = next_parts;
 	}
 }
+EXPORT_SYMBOL(cmdline_parts_free);
 
 int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline)
 {
@@ -206,6 +206,7 @@ fail:
 	cmdline_parts_free(parts);
 	goto done;
 }
+EXPORT_SYMBOL(cmdline_parts_parse);
 
 struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 					 const char *bdev)
@@ -214,17 +215,17 @@ struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 		parts = parts->next_parts;
 	return parts;
 }
+EXPORT_SYMBOL(cmdline_parts_find);
 
 /*
  *  add_part()
  *    0 success.
  *    1 can not add so many partitions.
  */
-void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
-		       int slot,
-		       int (*add_part)(int, struct cmdline_subpart *, void *),
-		       void *param)
-
+int cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		      int slot,
+		      int (*add_part)(int, struct cmdline_subpart *, void *),
+		      void *param)
 {
 	sector_t from = 0;
 	struct cmdline_subpart *subpart;
@@ -247,4 +248,7 @@ void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
 		if (add_part(slot, subpart, param))
 			break;
 	}
+
+	return slot;
 }
+EXPORT_SYMBOL(cmdline_parts_set);
diff --git a/include/linux/cmdline-parser.h b/include/linux/cmdline-parser.h
index 98e892e..43b65a9 100644
--- a/include/linux/cmdline-parser.h
+++ b/include/linux/cmdline-parser.h
@@ -35,9 +35,9 @@ int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline);
 struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 					 const char *bdev);
 
-void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
-		       int slot,
-		       int (*add_part)(int, struct cmdline_subpart *, void *),
-		       void *param);
+int cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		      int slot,
+		      int (*add_part)(int, struct cmdline_subpart *, void *),
+		      void *param);
 
 #endif /* CMDLINEPARSEH */
-- 
1.8.1.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
