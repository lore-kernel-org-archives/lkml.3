Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaCGKwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:52:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaCGKwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:52:07 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660333"
Message-ID: <5319A2CC.3090206@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:43:24 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] f2fs: update start nid only once each circle
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:30,
	Serialize complete at 2014/03/07 18:49:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/node.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8c14110..9653096 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1875,11 +1875,15 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	while ((found = __gang_lookup_nat_cache(nm_i,
 					nid, NATVEC_SIZE, natvec))) {
 		unsigned idx;
+
+		nid = nat_get_nid(natvec[found - 1]) + 1;
+
 		for (idx = 0; idx < found; idx++) {
 			struct nat_entry *e = natvec[idx];
-			nid = nat_get_nid(e) + 1;
+
 			__del_from_nat_cache(nm_i, e);
 		}
+
 	}
 	f2fs_bug_on(nm_i->nat_cnt);
 	write_unlock(&nm_i->nat_tree_lock);
-- 
1.7.7

