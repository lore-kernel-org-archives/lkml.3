Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3CLFgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:36:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5364 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab3CLFgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:36:43 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856497"
Message-ID: <513EBE8D.6050601@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:35:09 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/18] fs: befs: remove cast for kmalloc return value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:35:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:35:29,
	Serialize complete at 2013/03/12 13:35:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/befs/btree.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index a66c9b1..74e397d 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -436,8 +436,7 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 		goto error;
 	}
 
-	if ((this_node = (befs_btree_node *)
-	     kmalloc(sizeof (befs_btree_node), GFP_NOFS)) == NULL) {
+	if ((this_node = kmalloc(sizeof (befs_btree_node), GFP_NOFS)) == NULL) {
 		befs_error(sb, "befs_btree_read() failed to allocate %u "
 			   "bytes of memory", sizeof (befs_btree_node));
 		goto error;
-- 
1.7.1

