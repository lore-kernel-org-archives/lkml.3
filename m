Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3GHH4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:56:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab3GHH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:56:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,1018,1363104000"; 
   d="scan'208";a="7817992"
Message-ID: <51DA6FD5.8050300@cn.fujitsu.com>
Date: Mon, 08 Jul 2013 15:52:53 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: mfasheh@suse.com, jlbec@evilplan.org
CC: ocfs2-devel@oss.oracle.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ocfs2/refcounttree: add the missing NULL check of the return
 value of find_or_create_page()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/08 15:54:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/08 15:54:43,
	Serialize complete at 2013/07/08 15:54:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing NULL check of the return value of find_or_create_page() in
function ocfs2_duplicate_clusters_by_page().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/ocfs2/refcounttree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 998b17e..456d0e4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2965,7 +2965,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 			to = map_end & (PAGE_CACHE_SIZE - 1);

 		page = find_or_create_page(mapping, page_index, GFP_NOFS);
-
+		if (!page) {
+			ret = -ENOMEM;
+			mlog_errno(ret);
+			break;
+		}
 		/*
 		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
 		 * can't be dirtied before we CoW it out.
-- 
1.7.7

