Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3CLFik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:38:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab3CLFij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:38:39 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856519"
Message-ID: <513EBF01.2010401@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:37:05 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/18] fs: ufs: remove cast for kmalloc return value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:37:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:37:25,
	Serialize complete at 2013/03/12 13:37:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ufs/util.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/util.c b/fs/ufs/util.c
index 95425b5..b6c2f94 100644
--- a/fs/ufs/util.c
+++ b/fs/ufs/util.c
@@ -26,8 +26,7 @@ struct ufs_buffer_head * _ubh_bread_ (struct ufs_sb_private_info * uspi,
 	count = size >> uspi->s_fshift;
 	if (count > UFS_MAXFRAG)
 		return NULL;
-	ubh = (struct ufs_buffer_head *)
-		kmalloc (sizeof (struct ufs_buffer_head), GFP_NOFS);
+	ubh = kmalloc (sizeof (struct ufs_buffer_head), GFP_NOFS);
 	if (!ubh)
 		return NULL;
 	ubh->fragment = fragment;
-- 
1.7.1

