Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaCGKwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:52:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaCGKwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:52:17 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660335"
Message-ID: <5319A2D5.6060201@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:43:33 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] f2fs: format segment_info's show for better legibility
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:39,
	Serialize complete at 2014/03/07 18:49:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original segment_info's show is a bit out-of-format:

[root@guz Demoes]# cat /proc/fs/f2fs/loop0/segment_info
0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
......
0 0 0 0 0 0 0 0 0 0
0 0 1 0 0 1 [root@guz Demoes]#

so we fix it here for better legibility.
[root@guz Demoes]# cat /proc/fs/f2fs/loop0/segment_info
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
......
0 0 0 0 0 0 0 0 0 0
0 0 1 0 0 1
[root@guz Demoes]#

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/super.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 72df734..6e4851c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -546,11 +546,12 @@ static int segment_info_seq_show(struct seq_file *seq, void *offset)
 
 	for (i = 0; i < total_segs; i++) {
 		seq_printf(seq, "%u", get_valid_blocks(sbi, i, 1));
-		if (i != 0 && (i % 10) == 0)
-			seq_puts(seq, "\n");
+		if ((i % 10) == 9 || i == (total_segs - 1))
+			seq_putc(seq, '\n');
 		else
-			seq_puts(seq, " ");
+			seq_putc(seq, ' ');
 	}
+
 	return 0;
 }
 
-- 
1.7.7

