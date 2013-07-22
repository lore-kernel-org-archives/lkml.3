Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab3GVIhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:37:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab3GVIhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:37:09 -0400
X-IronPort-AV: E=Sophos;i="4.89,718,1367942400"; 
   d="scan'208";a="7975008"
Message-ID: <51ECEE5C.3060407@cn.fujitsu.com>
Date: Mon, 22 Jul 2013 16:33:32 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] f2fs/debug.c : use seq_puts()/seq_putc() rather than seq_printf()
 where possible
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/22 16:35:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/22 16:35:09,
	Serialize complete at 2013/07/22 16:35:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For string without format specifiers, using seq_puts()/seq_putc()
instead of seq_printf().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/debug.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index fd12b7f..a84b0a8 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -253,21 +253,21 @@ static int stat_show(struct seq_file *s, void *v)
 			   si->nats, NM_WOUT_THRESHOLD);
 		seq_printf(s, "  - SITs: %5d\n  - free_nids: %5d\n",
 			   si->sits, si->fnids);
-		seq_printf(s, "\nDistribution of User Blocks:");
-		seq_printf(s, " [ valid | invalid | free ]\n");
-		seq_printf(s, "  [");
+		seq_puts(s, "\nDistribution of User Blocks:");
+		seq_puts(s, " [ valid | invalid | free ]\n");
+		seq_puts(s, "  [");
 
 		for (j = 0; j < si->util_valid; j++)
-			seq_printf(s, "-");
-		seq_printf(s, "|");
+			seq_putc(s, '-');
+		seq_putc(s, '|');
 
 		for (j = 0; j < si->util_invalid; j++)
-			seq_printf(s, "-");
-		seq_printf(s, "|");
+			seq_putc(s, '-');
+		seq_putc(s, '|');
 
 		for (j = 0; j < si->util_free; j++)
-			seq_printf(s, "-");
-		seq_printf(s, "]\n\n");
+			seq_putc(s, '-');
+		seq_puts(s, "]\n\n");
 		seq_printf(s, "SSR: %u blocks in %u segments\n",
 			   si->block_count[SSR], si->segment_count[SSR]);
 		seq_printf(s, "LFS: %u blocks in %u segments\n",
-- 
1.7.7

